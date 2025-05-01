check_http() {
  website=${1:?Pass in a website as an argument}
  curl -sL -w "%{http_code}\n" "${website}" -o /dev/null | grep -q "200"
}

set_infra() {
  export INFRA_NODE
  INFRA_NODE=${1}

  export NOMAD_ADDR="https://nomad-ui.internal.demophoon.com"
  export VAULT_ADDR="https://vault-ui.internal.demophoon.com"
  export CONSUL_HTTP_ADDR="https://consul-ui.internal.demophoon.com"

  if [ "${1}" ] || ! check_http $CONSUL_HTTP_ADDR; then
    export VAULT_SKIP_VERIFY="true"
    export NOMAD_SKIP_VERIFY="true"
    export CONSUL_HTTP_SSL_VERIFY=false

    if type -p tailscale > /dev/null && ; then
      if [ -z "${INFRA_NODE}" ]; then
        INFRA_NODE=$(tailscale status --self=false --json | jq -r '.Peer | to_entries[].value | select(.Online) | .HostName' | grep -E "nuc-|proxmox-|sol-" | shuf | head -n1)
      else
        INFRA_NODE=$(tailscale ip ${INFRA_NODE} | head -n1)
      fi
    else
      INFRA_NODE=$(dig +short ${INFRA_NODE} | grep -Po "((\d{1,3}\.){3}\d{1,3})")
    fi
    export VAULT_ACTIVE=$(dig @${INFRA_NODE} -p8600 +short A active.vault.service.consul.demophoon.com)

    export NOMAD_ADDR="https://${INFRA_NODE}:4646"
    export VAULT_ADDR="https://${VAULT_ACTIVE}:8200"
    export CONSUL_HTTP_ADDR="https://${INFRA_NODE}:8501"
  fi
}

vault_login() {
  if [ -z "${VAULT_ADDR}" ]; then
    set_infra
  fi
  if [ -z "$(vault token lookup -format=json | jq -r .data.id)" ]; then
    vault login -method=oidc
  fi
}

sign_public_ssh_key() {
  local KEY=${1:-$HOME/.ssh/id_ed25519.pub}
  vault_login
  if [ ! -f "$KEY" ]; then
    echo "Unable to sign key. $KEY does not exist"
    return 1
  fi
  vault write -field=signed_key proxmox/sign/admin public_key=@"${KEY}" > "${KEY/.pub/-cert.pub}"
}

vault_ssh() {
  sign_public_ssh_key
}

terraform_env() {
  vault_login
  cat <({
    source <(vault kv get -format=json -mount=kv env/infra/terraform | jq -r '.data.data | keys[] as $k | "" + $k + "=" + (.[$k]) + ";"');
    terraform $@
  })
}
