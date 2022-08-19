#!/bin/bash
# Provisioner script using nix and ansible
#
# Requirements:
#
#
# Usage: provision.sh [options ...]
# Installs Nix and setups dotfiles and optionally starts managing the system
# with Ansible.
# Options:
#   -i: Interactive mode
#   -u: Uninstall

set -e

{ # Prevent script from running if partially downloaded
_NIX_VER=22.05
reminders=()
cleanup_steps=()
export _updated=
export _indent=0

# We will need to reset the path during the script
export PATH=$PATH
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}

# Colors
_B='\e[1m'
_e='\e[0m' # Reset
_r='\e[38;5;196m'  # Red
_g='\e[38;5;119m'  # Green
_b='\e[38;5;33m'   # Blue
_y='\e[38;5;226m'  # Yellow
_o='\e[38;5;208m'  # Orange
_w='\e[38;5;254m'  # White

_sg='\e[38;5;122m' # Sea Green
_gr='\e[38;5;246m' # Gray

# Printing utilities
with() { _indent=$(($_indent + 1)); }
endwith() { _indent=$(($_indent - 1)); }
_indent() {
  for i in $(seq 1 ${_indent} ); do
    echo -n "  "
  done
}
_print() {
  _indent
  echo -e "$*"
}
header()  { _indent=0; _print "${_b} ======= ${_e} ${_sg}$*${_e}${_b} =======${_e}"; }
success() { _print "${_g} ✓${_e} ${_w}$*${_e}"; }
failure() { _print "${_r} 𐄂${_e} ${_w}$*${_e}"; }
info()    { _print "${_b} *${_e} ${_w}$*${_e}"; }
warn()    { _print "${_y} ⚠ $*${_e}"; }
error()   { _print "${_r}!! $*${_e}"; exit 0; }

_run_with_line_cap() {
  lines=5
  output_file="$(mktemp .provisioner-install.XXXXX)"
  "$@" &> ${output_file:?} &
  pid=$!
  output=""
  llc=$(printf "${output}" | wc -l)
  while kill -0 $pid >/dev/null 2>&1; do
    lc=$(printf "${output}" | wc -l)
    if [ ${lc} -gt 0 ]; then
      for i in $(seq 0 $(( lc - llc )) ); do
        printf "\33[2K\r\n"
      done
      llc=${lc}
      for i in $(seq 0 $lc); do
        printf "\r\033[1A\033[2K\r"
      done
      printf "${_gr}${output}${_e}\r"
    fi
    cols=$(tput cols)
    output=$(tail -n ${lines} ${output_file:?} | sed -e "s/^/$(_indent)    > /" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | sed 's/^\(.\{'"${cols}"'\}\).*/\1/g')
    sleep .1
  done
  if [ -n "$output" ]; then
    echo ""
  fi
  rm -f ${output_file:?}
}

run() {
    info "Running '${_gr}$*${_w}'"
    _run_with_line_cap "$@"
}

add_cleanup() {
  cleanup_steps+=("$*")
}
cleanup() {
  if [ ${#cleanup_steps[@]} -eq 0 ]; then
    return
  fi
  header "Cleaning up..."; with
    for step in "${cleanup_steps[@]}"; do
        run ${step}
    done
  endwith
}

command_exists() { type "$1" &> /dev/null; }
nix_command_exists() { PATH=~/.nix-profile/bin type "$1" &> /dev/null; }
is_function() {
    case $(type -t "$1") in
        function) return 0
    esac
    return 1
}

show_reminders() {
  if [ ${#reminders[@]} -eq 0 ]; then
    header "Finished!"
    return
  fi
  header "Before you can start"; with
    for r in "${reminders[@]}"; do
      warn "$r"
    done
  endwith
}
add_reminder() {
  reminders+=("$*")
}
require() {
    if ! command_exists "$1"; then
        error "$1 is required but not installed."
    fi
}
find_first_command() {
    for cmd in "${@}"; do
        if command_exists $cmd; then
            echo $cmd
            return 0
        fi
    done
    return 1
}
native_install_if_missing() {
    cmd=$1
    shift
    pkg=${1:-${cmd}}
    if ! command_exists "${cmd:?}" ; then
        install_pkg "$pkg"
        success "${_w}'${_gr}${cmd}${_w}' installed"
    else
        success "${_w}'${_gr}${cmd}${_w}' installed"
    fi
}

install_if_missing() {
    cmd=$1
    shift
    pkg=${1:-$cmd}
    if ! command_exists "${cmd:?}" || ! nix_command_exists "${cmd:?}" ; then
        install_command="${1:-install_$cmd}"
        if is_function "${install_command:?}"; then
          "${install_command:?}"
        else
          install_with_nix "${pkg}"
          success "${_w}'${_gr}${cmd}${_w}' installed"
        fi
    else
        success "${_w}'${_gr}${cmd}${_w}' installed"
    fi
}

install_pkg() {
  pkg=$1
  installer=$(find_first_command apt yum)
  case $installer in
    apt)
      if [ -n _updated ]; then
          run sudo apt update
          _updated=1
      fi
      with
      run sudo apt install "$pkg" -y
      endwith
      return 0
      ;;
    yum)
      if [ -n _updated ]; then
          run sudo yum update
          _updated=1
      fi
      with
      run sudo yum install "$pkg" -y
      endwith
      return 0
      ;;
  esac
  return 1
}

install_with_nix() {
    require nix
    info "Installing $1..."
  with
    run nix-env -i "$1"
  endwith
}

install_nix() {
  if command_exists nix; then
    return 0
  fi
  info "Installing Nix"; with
    sudo install -d -m755 -o $(id -u) -g $(id -g) /nix
    install_file="./$(mktemp nix-install.XXXXX.sh)"
    add_cleanup rm -f "${install_file:?}"
    run curl -L https://nixos.org/nix/install -o "${install_file:?}"
    run chmod +x "${install_file:?}"
    run "${install_file:?}"
    _setup_nix
    add_reminder "You will need to either restart your terminal or run \nsource $HOME/.nix-profile/etc/profile.d/nix.sh\n to start using Nix"
    add_reminder "Run `chsh -s /bin/zsh` to use zsh"
  endwith;
}

update_nix() {
  require nix-channel
  info "Updating Nix channels..."; with
    run nix-channel --add "https://channels.nixos.org/nixos-${_NIX_VER:?}"
    run nix-channel --update
  endwith
}

install_home-manager() {
  run nix-channel --add "https://github.com/nix-community/home-manager/archive/release-${_NIX_VER:?}.tar.gz" home-manager
  run nix-channel --update
  run nix-shell '<home-manager>' -A install
  run nix-env --set-flag priority 6 "$(nix-env -q | grep nix)"
}

uninstall_nix() {
  header "Uninstalling Nix"; with
    run sudo systemctl stop nix-daemon.socket
    run sudo systemctl stop nix-daemon.service
    run sudo systemctl disable nix-daemon.service
    run sudo systemctl disable nix-daemon.socket
    run sudo systemctl daemon-reload
    run sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
    run sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
    run sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc
    run sudo mv /etc/zsh/zshrc.backup-before-nix /etc/zsh/zshrc
    run sudo rm -rf /etc/nix /nix /root/.nix-profile /root/.nix-defexpr /root/.nix-channels /home/britt/.nix-profile /home/britt/.nix-defexpr /home/britt/.nix-channels
  endwith
}

# Dotfile utils
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=${HOME:?}
merge_directories=(
    .config/nixpkgs
)
realize_directories() {
    filepath=${1:?}
    realize_path="${HOMEDIR:?}/${filepath%/*}"
    if [ ! -d "${realize_path:?}" ]; then
        run mkdir -p "${realize_path:?}"
    fi
}

deep_merge_dirs() {
    mergePath=${1:?}
    if [ ! -d ${mergePath:?} ]; then
        if [ -e ${mergePath:?} ]; then
            dotfiles_file=${mergePath#$DIR/}
            realize_directories ${dotfiles_file}
            run rm -f "${HOMEDIR:?}/${dotfiles_file:?}"
            run ln -s "${DIR:?}/${dotfiles_file:?}" "${HOMEDIR:?}/${dotfiles_file:?}"
        fi
    else
        for dir in $(find ${mergePath:?}/* -maxdepth 0); do
            deep_merge_dirs "${dir:?}"
        done
    fi
}

merge_dirs() {
  info "Linking Nixpkgs..."
  with
    for dir in ${merge_directories:?}; do
        deep_merge_dirs "${DIR:?}/${dir:?}"
    done
  endwith
  success "Nixpkgs linked"
}

initialize_home_manager() {
  require home-manager
  run home-manager switch -b backup
  success "Dotfiles installed"
  add_reminder "Dotfiles have been installed but old paths may still remain in this shell. Restart your shell to activate dotfiles."
}

_setup_nix() {
  [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh" || :
}

update_home_manager() {
  _setup_nix
  add_links

  require home-manager
  header "Initializing home directory"; with
    initialize_home_manager
  endwith
}

main() {
  header "Installing Nix"; with
    _setup_nix
    native_install_if_missing curl
    native_install_if_missing xz xz-utils
    native_install_if_missing zsh
    install_nix
    update_nix
  endwith;

  require nix
  header "Installing home-manager"; with
    install_if_missing home-manager
  endwith

  update_home_manager

  show_reminders
}

add_links() {
  header "Injecting dotfile configurations"; with
    merge_dirs
  endwith

}

trap "cleanup; exit" EXIT

case $1 in
  uninstall)
    set +e
    uninstall_nix
    ;;
  links)
    add_links
    ;;
  update)
    update_home_manager
    ;;
  *)
    main
    ;;
esac
}
