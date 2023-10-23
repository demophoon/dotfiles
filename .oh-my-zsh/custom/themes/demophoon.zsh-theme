# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

setopt prompt_subst
autoload colors
colors

autoload -U add-zsh-hook
autoload -Uz vcs_info

eval PR_BOLD="%{$terminfo[bold]%}"
#use extended color pallete if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
  MAGENTA="%F{9}$PR_BOLD"
  ORANGE="%F{172}$PR_BOLD"
  GREEN="%F{190}$PR_BOLD"
  PURPLE="%F{141}$PR_BOLD"
  BLUE="%F{27}$PR_BOLD"
  WHITE="%F{0}$PR_BOLD"
  TEXT="%F{7}"
  GREY="%F{237}"
  RED="%F{161}$PR_BOLD"

  GITGREEN="%F{2}"
  GITRED="%F{1}"
  GITGREY="%F{8}"

  turquoise="%F{81}"
  orange="%F{166}"
  purple="%F{135}"
  hotpink="%F{161}"
  limegreen="%F{118}"
else
  MAGENTA=$(tput setaf 5)
  ORANGE=$(tput setaf 4)
  GREEN=$(tput setaf 2)
  PURPLE=$(tput setaf 1)
  BLUE=$(tput setaf 4)
  WHITE=$(tput setaf 7)
  GREY=$(tput setaf 7)
  RED="%fg[red]"

  GITGREEN=${GREEN}
  GITRED=${RED}
  GITGREY=${GREY}

  turquoise="$fg[cyan]"
  orange="$fg[yellow]"
  purple="$fg[magenta]"
  hotpink="$fg[red]"
  limegreen="$fg[green]"
fi

# enable VCS systems you use
zstyle ':vcs_info:*' enable git

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('$fg[blue]`basename $VIRTUAL_ENV`%{$GREY%}') '
}
PR_GIT_UPDATE=1

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%{${reset_color}%}"
DEFAULT_FMT_BRANCH="on %{$PURPLE%}%b %u%${PR_RST}"
DEFAULT_FMT_ACTION="(%{$GREEN%}%a${PR_RST})"
DEFAULT_FMT_UNSTAGED="%{$ORANGE%}U${PR_RST}"
DEFAULT_FMT_STAGED=""

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:prompt:*' unstagedstr   "${DEFAULT_FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${DEFAULT_FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${DEFAULT_FMT_BRANCH}${DEFAULT_FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${DEFAULT_FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_preexec {
  case "$(history $HISTCMD)" in
    *git*|*gs*|*ga*|*gc*|*gp*|*gl*|*gd*|*gf*|*ls*)
      PR_GIT_UPDATE=1
      ;;
    *svn*)
      PR_GIT_UPDATE=1
      ;;
  esac
}
add-zsh-hook preexec steeef_preexec

function steeef_chpwd {
  PR_GIT_UPDATE=1
}
add-zsh-hook chpwd steeef_chpwd

function _current_time {
  date +"%T"
}

function git_blocks {
  git_stats=$(git diff --shortstat --cached)

  if echo $git_stats | grep -q "insertion"; then
    git_insertions=$(echo $git_stats | sed -E 's/.* ([0-9]+) insertions?.*?/\1/')
  else
    git_insertions=0
  fi

  if echo $git_stats | grep -q "deletion"; then
    git_deletions=$(echo $git_stats | sed -E 's/.* ([0-9]+) deletions?.*?/\1/')
  else
    git_deletions=0
  fi

  git_moved_lines=$(git diff --name-only --cached --diff-filter="R" | xargs -n1 wc -l | awk '{s+=$1} END {printf "%.0f\n", s}')
  git_touched_lines=$(( git_insertions + git_deletions + git_moved_lines ))

  if [ $git_touched_lines -gt 0 ]; then
    if [ $git_moved_lines -gt 0 ]; then
      git_num_add_blocks=$(( git_insertions * 5 / git_touched_lines ))
      git_num_del_blocks=$(( git_deletions * 5 / git_touched_lines ))
      git_num_neu_blocks=$(( 5 - (git_num_add_blocks + git_num_del_blocks) ))
    else
      git_num_del_blocks=$(( git_deletions * 5 / git_touched_lines ))
      git_num_add_blocks=$(( 5 - git_num_del_blocks ))
      git_num_neu_blocks=0
    fi

    git_block_char="■"

    git_add_blocks=""
    if [ $git_num_add_blocks -gt 0 ]; then
      git_add_blocks=$(printf "${git_block_char}%.0s" {1..$git_num_add_blocks})
    fi

    git_del_blocks=""
    if [ $git_num_del_blocks -gt 0 ]; then
      git_del_blocks=$(printf "${git_block_char}%.0s" {1..$git_num_del_blocks})
    fi

    git_neu_blocks=""
    if [ $git_num_neu_blocks -gt 0 ]; then
      git_neu_blocks=$(printf "${git_block_char}%.0s" {1..$git_num_neu_blocks})
    fi

    git_stats="${GITGREEN}+${git_insertions:-0}${GITRED}-${git_deletions:-0}${PR_RST}"
    git_blocks_out="${GITGREEN}$git_add_blocks${GITRED}$git_del_blocks${GITGREY}${git_neu_blocks}${PR_RST}"
    echo "${git_stats} ${git_blocks_out}"
  fi
}

function steeef_precmd {
  if [[ -n "$PR_GIT_UPDATE" ]] ; then
    if $(git -C . rev-parse 2>/dev/null); then
      FMT_BRANCH="${DEFAULT_FMT_BRANCH}$(git_blocks)"
    else
      FMT_BRANCH="${DEFAULT_FMT_BRANCH}"
    fi

    zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"

    vcs_info 'prompt'
    PR_GIT_UPDATE=
  fi
}
add-zsh-hook precmd steeef_precmd

function _cmd_timer_start() {
  _timer=${_timer:-$SECONDS}
}
function _cmd_timer_end() {
  _timer=${_timer:-$SECONDS}
  _last_cmd_time=$(($SECONDS - $_timer))
  unset _timer
}
add-zsh-hook preexec _cmd_timer_start

function prompt-length() {
  emulate -L zsh
  local -i COLUMNS=${2:-COLUMNS}
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  typeset -g REPLY=$x
}

# Usage: fill-line LEFT RIGHT
#
# Sets REPLY to LEFT<spaces>RIGHT with enough spaces in
# the middle to fill a terminal line.
function fill-line() {
  emulate -L zsh
  prompt-length $1
  local -i left_len=REPLY
  prompt-length $2 9999
  local -i right_len=REPLY
  local filler=${3:- }
  local fill_fmt=${4:- }
  local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1} + 3))
  if (( pad_len < 1 )); then
    # Not enough space for the right part. Drop it.
    typeset -g REPLY=$1
  else
    local pad=${(pl.$pad_len..$filler.)}  # pad_len spaces
    typeset -g REPLY="${1} ${fill_fmt}${pad}%{$GREY%} ${2}"
  fi
}

_fmt_duration() {
  in=$1
  msg=""
  if [ $1 -gt 3600 ]; then
    hr=$(( in / 60 / 60 ))
    remain=$(( in - (hr * 60 * 60) ))
    msg+="${hr}h$(_fmt_duration $remain)"
  elif [ $1 -gt 60 ]; then
    min=$(( in / 60 ))
    remain=$(( in - (min * 60) ))
    msg+="${min}m$(_fmt_duration $remain)"
  elif [ $1 -gt 0 ]; then
    msg+="${1}s"
  fi
  echo $msg
}

# Sets PROMPT and RPROMPT.
#
# Requires: prompt_percent and no_prompt_subst.
function set-prompt() {
  exit_code="$?"
  _cmd_timer_end
  emulate -L zsh
  local git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  git_branch=${git_branch//\%/%%}  # escape '%'

  exit_msg=""
  fill=" "
  if (( exit_code > 0 )); then
    exit_fmt="%{$RED%}"
    exit_msg="${exit_fmt}Exit code: ${exit_code}${GREY} | "
    fill="="
  fi

  timer_msg=""
  if (( _last_cmd_time > 0 )); then
    timer_msg="$(_fmt_duration ${_last_cmd_time}) | "
  fi

  _current_dir_color="${GREEN}"
  if type "direnv" > /dev/null; then
    if direnv status | grep allowed | grep -q true; then
      _current_dir_color="${BLUE}"
    fi
  fi

  local top_left="${MAGENTA}%n${GREY} at ${ORANGE}%m${GREY} in ${_current_dir_color}%~${GREY} ${vcs_info_msg_0_} $(virtualenv_info)"
  local top_right="${GREY}[ ${exit_msg}${timer_msg}!%h ${GREY}]${reset_color}"
  local bottom_left="%{$GREY%}\$%{$reset_color%} ${TEXT}"
  local bottom_right="%{$BLUE%}$(_current_time)%{$reset_color%}"

  local REPLY
  fill-line "$top_left" "$top_right" "$fill" "$exit_fmt"
  PROMPT=$REPLY$'\n'$bottom_left
  RPROMPT=$bottom_right
}

setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt
