# Helpers
command_exists() {
    type "${1}" &> /dev/null ;
}

# Common Aliases
# s3cmd encrypted
#
function s3cmde() {
    if [ -f ~/.s3cfg.encrypted ]; then
        gpg --decrypt -o ~/.s3cfg ~/.s3cfg.encrypted
        s3cmd $@
        rm ~/.s3cfg
    else
        s3cmd $@
    fi
}

# xclipboard aliases
alias clipcopy="xclip -selection c"
alias clippaste="xclip -selection c -o"

if command_exists hub; then
  alias git='hub'
fi

# Improved Kubernetes alias
k() {
    action=$1
    shift
    namespace=${namespace:-default}
    executable="kubectl"
    flags=''
    k_type=''

    case $action in
        d|del|delete)
            flags+='--wait=false'
            action='delete'
            ;;
        p)
            k_type='pods'
            action='get'
            ;;
        d)
            k_type='deployments'
            action='get'
            ;;
        n)
            k_type='namespaces'
            action='get'
            ;;
        se|ss)
            k_type='secrets'
            action='get'
            ;;
        sv)
            k_type='services'
            action='get'
            ;;
        pod*|st*|deployment*|d|job*|svc*|secret*|cm*|pvc*|namespace*)
            k_type=$action
            action='get'
            ;;
        describe)
            if echo $1 | grep -q "/"; then
                k_type="${@}"
            else
                k_type="pod/${@}"
            fi
            ;;
        watch)
            eval "_WATCH=true k $*"
            return $?
            ;;
        redeploy|fuckit)
            action='delete'
            k_type='pod'
            flags+='-lkustomize.version=v0.1'
            ;;
        g|get)
            if [ "$1" = 'fucked' ]; then
                shift
                eval "k redeploy"
                return $?
            fi
            ;;
        context|contexts|get-context|get-contexts)
            action='config'
            k_type='get-contexts'
            ;;
        log|logs)
            executable="stern"
            action=''
            ;;
    esac
    k_type=${k_type:-$@}
    command="${executable} ${action} -n ${namespace} ${k_type} ${flags}"
    if [ ! -z "$_WATCH" ]; then
        command="watch -n .5 --no-title '${command}'"
    fi
    >&2 echo $command
    eval "$command"
}

_color() {
    case "$1" in
        grey|gray)
            echo "\e[1;30;1;40m"
        ;;
        purple)
            echo "\e[4;35m"
        ;;
        reset)
            echo "\e[0m"
        ;;
    esac
}

_info() {
    >&2 echo "$(_color gray)${*}$(_color reset)"
}

_run() {
    _info "\$ $@"
    "$@"
}

cmd_mocker() {
    base=$1
    found=""
    fargs=""
    shift
    for face in "$@"; do
        shift
        fn="${base}_${face}"
        if type $fn | grep -q "function" ; then
          found="${fn}"
          fargs="${@}"
        fi
        base="$fn"
    done
    if [ -n "${found}" ]; then
        echo "${found}" "${fargs}"
        return 0
    fi
    return 1
}

WAYPOINT_SRC=0
waypoint() {
    if [[ $ZSH_SUBSHELL -eq 0 ]]; then
        use_echo=1
    else
        use_echo=0
    fi
    fn=($(cmd_mocker waypoint "$@"))
    if [ -n "$fn" ]; then
      _invoke "${fn[@]}"
      return $?
    fi
    case "$1" in
        bin)
            _info "Using waypoint from $(_color purple)bin$(_color reset)"
            WAYPOINT_SRC=0
            return 0
        ;;
        src)
            _info "Using waypoint from $(_color purple)source$(_color reset)"
            WAYPOINT_SRC=1
            return 0
        ;;
        sys|pkg|system|package|packaging)
            _info "Using waypoint from $(_color purple)packaging$(_color reset)"
            WAYPOINT_SRC=2
            return 0
        ;;
        hcp)
            context=$(waypoint context list | grep "api.hcp.dev:443" | awk '{ gsub(/ /,""); print $2}' FS='|')
            if [ -z ${context} ]; then
                echo "HCP Context not found"
                return 1
            fi
            waypoint context use "${context}"
            return 0
        ;;
        use)
            shift
            if [ -f $1 -a -x $1 ]; then
                WAYPOINT_SRC=$(realpath $1)
                _info "Using waypoint from $(_color purple)${WAYPOINT_SRC}$(_color reset)"
            else
                waypoint "$@"
            fi
            return 0
        ;;
        docker|kubernetes|ecs|nomad)
            platform=$1
            install_flags=()
            shift
            case $platform in
                kubernetes)
                    short_platform=k8s
                ;;
                ecs)
                    install_flags+=("-ecs-region" "us-east-2")
                    install_flags+=("-ecs-cluster" "britt-waypoint-server")
                ;;
                *)
                    short_platform=$platform
                ;;
            esac

            action=$1
            shift

            case $action in
                install)
                    install_flags+=('-accept-tos')
                    install_flags+=("${@}")
                    _run waypoint install -platform $platform "${install_flags[@]}"
                    return 0
                ;;
                server-install)
                    install_flags+=('-accept-tos')
                    install_flags+=("${@}")
                    pushd /home/britt/projects/waypoint
                    make bin
                    make docker/server
                    svr_img="waypoint:dev"
                    odr_img="waypoint-odr:dev"
                    if [ $platform != "docker" ]; then
                        registry="registry.services.demophoon.com"
                        svr_img="${registry}/${svr_img}"
                        odr_img="${registry}/${odr_img}"
                        docker tag waypoint:dev "${svr_img}"
                        docker tag waypoint-odr:dev "${odr_img}"
                        docker push "${svr_img}"
                        docker push "${odr_img}"
                    fi
                    popd
                    _run waypoint install -platform $platform "-${short_platform}-server-image=${svr_img}" "-${short_platform}-odr-image=${odr_img}" "${install_flags[@]}"
                    return 0
                ;;
                uninstall)
                    install_flags+=("${@}")
                    _run waypoint server uninstall -auto-approve "${install_flags[@]}"
                    return 0
                ;;
                *)
                    echo "No command found"
                    return 1
                ;;
            esac
        ;;
    esac

    if [ "$WAYPOINT_SRC" = "0" ]; then
        _waypoint="/home/britt/projects/waypoint/cmd/waypoint"
        [[ $use_echo = 1 ]] && _info "$(_color grey)Using ${_waypoint} ($(_color purple)$(waypoint version -plain | head -n1)$(_color gray))$(_color reset)"
    elif [ "$WAYPOINT_SRC" = "1" ]; then
        _waypoint=("go" "run" "/home/britt/projects/waypoint/cmd/waypoint")
        [[ $use_echo = 1 ]] && _info "$(_color grey)Using ${_waypoint} ($(_color purple)CLI: Source$(_color gray))$(_color reset)"
    elif [ "$WAYPOINT_SRC" = "2" ]; then
        _waypoint=$(echo =waypoint)
        [[ $use_echo = 1 ]] && _info "$(_color grey)Using ${_waypoint} ($(_color purple)$(waypoint version -plain | head -n1)$(_color gray))$(_color reset)"
    else
        _waypoint=${WAYPOINT_SRC}
        [[ $use_echo = 1 ]] && _info "$(_color grey)Using ${_waypoint} ($(_color purple)$(waypoint version -plain | head -n1)$(_color gray))$(_color reset)"
    fi

    $_waypoint "$@"
}

devshell() {
  command=${1}
  shift
  case $command in
    new)
      nix flake new -t github:demophoon/devshell ${1:-./}
    ;;
    help|*)
      echo "devshell <command> [options]"
      echo "  Commands:"
      echo "    new"
      echo "      Instanciate a new devshell for a project given a path (Defaults to current working directory)"
      echo
      echo "    help"
      echo "      Show this help menu."
    ;;
  esac
}
