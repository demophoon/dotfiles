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
    WHITE="%F{0}$PR_BOLD"
    GREY="%F{237}"
    RED="%F{161}$PR_BOLD"

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
    WHITE=$(tput setaf 7)
    GREY=$(tput setaf 7)
    RED="%fg[red]"

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
FMT_BRANCH="(%{$PURPLE%}%b%u%c${PR_RST})"
FMT_ACTION="(%{$GREEN%}%a${PR_RST})"
FMT_UNSTAGED="%{$ORANGE%}●${PR_RST}"
FMT_STAGED="%{$GREEN%}●${PR_RST}"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_preexec {
    case "$(history $HISTCMD)" in
        *git*|gs*|ga*|gc*|gp*|gl*|gd*|gf*)
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

function steeef_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # check for untracked files or updated submodules, since vcs_info doesn't
        if git ls-files --other --exclude-standard 2> /dev/null | grep -q "."; then
            PR_GIT_UPDATE=1
            FMT_BRANCH="%{$GREY%}on %{$PURPLE%}%b%u%c%{$RED%}●${PR_RST}"
        else
            FMT_BRANCH="%{$GREY%}on %{$PURPLE%}%b%u%c${PR_RST}"
        fi
        zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH} "

        vcs_info 'prompt'
        PR_GIT_UPDATE=
    fi
}
add-zsh-hook precmd steeef_precmd

RPROMPT='hello world'
PROMPT=$'%{$MAGENTA%}%n%{$GREY%} at %{$ORANGE%}%m%{$GREY%} in %{$GREEN%}%~%{$GREY%} $vcs_info_msg_0_$(virtualenv_info)
%{$GREY%}$ %{$reset_color%}'
