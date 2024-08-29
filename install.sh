#!/usr/bin/env bash
# Provisioner script using nix
#
# Usage: provision.sh [command]
# Installs Nix and setups dotfiles on a machine
# Commands:
#   <Default>: Install nix, home-manager, and dotfiles.
#   update: Update nix channel for home manager.
#   links: Installs the symlinks for dotfiles only.
#   uninstall: Uninstalls nix from the machine. <Dangerous>
#              *This does not remove symlinks created by this script*
#

set -e

{ # Prevent script from running if partially downloaded
_NIX_VER=b3fcfcfabd01b947a1e4f36622bbffa3985bdac6
_HM_VER=44677a1c96810a8e8c4ffaeaad10c842402647c1
reminders=()
cleanup_steps=()
export _updated=
export _indent=0

# We will need to reset the path during the script
export PATH=$PATH
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}

# Colors
#for i in $(seq 0 256); do
#  printf "$(tput setaf $i)[$i] "
#done
if [ -n "$TERM" ]; then
  _B='\e[1m'
  _e="$(tput sgr0)"       # Reset
  _r="$(tput setaf 196)"  # Red
  _g="$(tput setaf 119)"  # Green
  _b="$(tput setaf 33)"   # Blue
  _y="$(tput setaf 226)"  # Yellow
  _o="$(tput setaf 208)"  # Orange
  _w="$(tput setaf 254)"  # White
  _sg="$(tput setaf 122)" # Sea Green
  _gr="$(tput setaf 246)" # Gray
else
  _B=''
  _e=''
  _r=''
  _g=''
  _b=''
  _y=''
  _o=''
  _w=''
  _sg=''
  _gr=''
fi

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
  "$@" > ${output_file:?} 2>&1 &
  pid=$!
  output=""
  llc=$(printf "${output}" 2> /dev/null | wc -l)
  errfail=0
  case $- in
    *e*) errfail=1 ;;
  esac

  set +e
  while kill -0 $pid >/dev/null 2>&1; do
    lc=$(printf -- "${output//%/%%}" | wc -l)
    if [ ${lc} -gt 0 ]; then
      for i in $(seq 0 $(( lc - llc )) ); do
        printf "\33[2K\r\n"
      done
      llc=${lc}
      for i in $(seq 0 $lc); do
        printf "\r\033[1A\033[2K\r"
      done
      printf -- "${_gr}${output//%/%%}${_e}\r"
    fi
    cols=$(tput cols)
    output=$(tail -n ${lines} ${output_file:?} | sed -e "s/^/$(_indent)    │ /" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | sed 's/^\(.\{'"${cols}"'\}\).*/\1/g')
    sleep .1
  done
  wait $pid
  ec=$?
  if [ $errfail = 1 ]; then
    set -e
  fi
  if [ -n "$output" ]; then
    echo ""
  fi
  if [ $ec -ne 0 ]; then
    cat ${output_file:?}
    if [ $errfail = 1 ]; then
      error "'$@' exited with non-zero exit code"
    fi
  fi
  rm -f ${output_file:?}
  return $ec
}

run() {
  info "Running '${_gr}$*${_w}'"

  if [ -n "$TERM" ]; then
    _run_with_line_cap "$@"
  else
    "$@"
  fi
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
  case $(echo $OSTYPE) in
    darwin*)
      echo "Install pkg not supported on this platform"
      return 0
      ;;
  esac
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
    success "${_w}'${_gr}nix${_w}' installed"
    return 0
  fi
  info "Installing Nix"; with
    install_file="./$(mktemp nix-install.XXXXX.sh)"
    add_cleanup rm -f "${install_file:?}"
    run curl --tlsv1.2 -sSf -o "${install_file:?}" -L https://install.determinate.systems/nix
    run chmod +x "${install_file:?}"
    run "${install_file:?}" install --no-confirm
    _setup_nix
    add_reminder "You will need to either restart your terminal or run \nsource $HOME/.nix-profile/etc/profile.d/nix.sh\n to start using Nix"
    add_reminder "Run `chsh -s /bin/zsh` to use zsh"
  endwith;
  update_nix
}

update_nix() {
  require nix
  info "Updating Nix channels..."; with
    run nix-channel --add "https://github.com/NixOS/nixpkgs/archive/${_NIX_VER}.tar.gz" nixpkgs
    run nix-channel --update
  endwith
}

install_home-manager() {
  run nix-channel --add "https://github.com/nix-community/home-manager/archive/${_HM_VER}.tar.gz" home-manager
  __nix_bin="$(nix-env -q | grep nix)"
  if [ -n "$__nix_bin" ]; then
    run nix-env --set-flag priority 4 "${__nix_bin:?}"
  fi
  run nix-channel --update
  run nix-shell '<home-manager>' -A install -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/${_NIX_VER}.tar.gz
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
    run sudo rm -rf /etc/nix /nix /root/.nix-profile /root/.nix-defexpr /root/.nix-channels
    run rm -rf ${HOME:?}/.nix-profile ${HOME:?}/.nix-defexpr ${HOME:?}/.nix-channels ${HOME:?}/.local/state/nix/profiles/home-manager* ${HOME:?}/.local/state/home-manager/gcroots/current-home
  endwith
}

# Dotfile utils
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOMEDIR=${HOME:?}
merge_directories=(
    .config/home-manager
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
            if [ ! -L "${HOMEDIR:?}/${dotfiles_file:?}" ]; then
              run rm -f "${HOMEDIR:?}/${dotfiles_file:?}"
              run ln -s "${DIR:?}/${dotfiles_file:?}" "${HOMEDIR:?}/${dotfiles_file:?}"
            fi
        fi
    else
        for dir in $(find ${mergePath:?}/* -maxdepth 0); do
            deep_merge_dirs "${dir:?}"
        done
    fi
}

merge_dirs() {
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
  [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" || :
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
  header "Installation Pre-Flight"; with
    _setup_nix
    native_install_if_missing curl
    native_install_if_missing xz xz-utils
    native_install_if_missing zsh
  endwith;

  header "Installing Nix"; with
    install_nix
  endwith;

  require nix
  header "Installing home-manager"; with
    install_if_missing home-manager
  endwith

  update_home_manager
}

update() {
  header "Updating nix..."; with
    update_nix
    install_home-manager
  endwith
  main
}

add_host_override() {
    override="${DIR:?}/.config/home-manager/profiles/${DOTFILE_PROFILE}/home.nix"
    if [ -f "${override}" ]; then
      info "Using '${override:?}'"
      run rm -f "${HOMEDIR:?}/.config/home-manager/home.nix"
      run ln -s "${override:?}" "${HOMEDIR:?}/.config/home-manager/home.nix"
    fi

}

add_links() {
  header "Injecting dotfile configurations"; with
    merge_dirs
  endwith
  add_host_override
}

trap "cleanup; exit" EXIT

while [[ $# -gt 0 ]]; do
  key=$1
  shift
  arg=${1:-""}
  case $key in
    -p|--profile)
      if [ -n "${arg:-''}" ]; then
        DOTFILE_PROFILE=$arg
      fi
      ;;
  esac
done

DOTFILE_PROFILE=${DOTFILE_PROFILE:-$(hostname)}

case $1 in
  uninstall)
    set +e
    uninstall_nix
    ;;
  links)
    add_links
    ;;
  update)
    update
    ;;
  *)
    main
    ;;
esac

show_reminders

}
