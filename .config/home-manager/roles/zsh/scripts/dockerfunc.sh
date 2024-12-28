#!/bin/bash
# Bash wrappers for docker run commands
#
# Credit and Inspiration: @jessfraz
# https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc

#
# Helper Functions
#
dcleanup(){
    local containers
    containers=( $(docker ps -aq 2>/dev/null) )
    docker rm "${containers[@]}" 2>/dev/null
    local volumes
    volumes=( $(docker ps --filter status=exited -q 2>/dev/null) )
    docker rm -v "${volumes[@]}" 2>/dev/null
    local images
    images=( $(docker images --filter dangling=true -q 2>/dev/null) )
    docker rmi "${images[@]}" 2>/dev/null
}
del_stopped(){
    local name=$1
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

    if [[ "$state" == "false" ]]; then
        docker rm "$name"
    fi
}
relies_on(){
    for container in "$@"; do
        local state
        state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

        if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
            echo "$container is not running, starting it for you."
            $container
        fi
    done
}
# creates an nginx config for a local route
nginx_config(){
    server=$1
    route=$2

    cat >"${HOME}/.nginx/conf.d/${server}.conf" <<-EOF
    upstream ${server} { server ${route}; }
    server {
    server_name ${server};
    location / {
    proxy_pass  http://${server};
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$remote_addr;
    proxy_set_header X-Forwarded-Port \$server_port;
    proxy_set_header X-Request-Start \$msec;
}
    }
EOF

    # restart nginx
    docker restart nginx

    # add host to /etc/hosts
    hostess add "$server" 127.0.0.1

    # open browser
    browser-exec "http://${server}"
}

registry() {
    docker run -d \
    -p 5000:5000 \
    --restart=always \
    --name registry \
    registry:2
}

electrum() {
    docker run -it --rm \
        --net=host \
        --env="DISPLAY=${DISPLAY:?}" \
        -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
        -v "${HOME}/.electrum/:/root/.electrum/:rw" \
        --privileged \
        electrum
}

ctop() {
    docker run --rm -ti \
          --name=ctop \
          --volume /var/run/docker.sock:/var/run/docker.sock:ro \
          quay.io/vektorlab/ctop:latest
}
