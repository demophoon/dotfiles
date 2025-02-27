set_infra() {
  export NOMAD_ADDR="https://nomad-ui.internal.demophoon.com"
  export VAULT_ADDR="https://vault-ui.internal.demophoon.com"
  export CONSUL_HTTP_ADDR="https://consul-ui.internal.demophoon.com"
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
