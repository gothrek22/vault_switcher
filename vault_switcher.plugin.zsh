#!/bin/bash

function vgp() {
  echo $VAULT_PROFILE
}

# vault profile selection
function vsp() {
  if [[ -z "$1" ]]; then
    unset VAULT_PROFILE VAULT_ADDR VAULT_TOKEN
    echo VAULT profile cleared.
    return
  fi

  local available_profiles=($(vault_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${VAULT_CREDENTIALS_FILE:-$HOME/.vault/credentials}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  PROFILE=$1
  export VAULT_PROFILE=$PROFILE
  export VAULT_ADDR=$(yq e ".$PROFILE.address" ~/.vault/credentials)
  role_id=$(yq e ".$PROFILE.role_id" ~/.vault/credentials)
  echo $role_id
  if [[ -n "${role_id}" ]]; then
    export VAULT_ROLE_ID=${role_id}
    export VAULT_SECRET_ID=$(yq e ".$PROFILE.secret_id" ~/.vault/credentials)
    unset VAULT_TOKEN
  else
    export VAULT_TOKEN=$(yq e ".$PROFILE.token" ~/.vault/credentials)
  fi
  unset role_id
  unset PROFILE
}

function vault_profiles() {
  [[ -r "${VAULT_CREDENTIALS_FILE:-$HOME/.vault/credentials}" ]] || return 1
  yq e '.|keys' "${VAULT_CREDENTIALS_FILE:-$HOME/.vault/credentials}"
}

function _vault_profiles() {
  reply=($(vault_profiles))
}
compctl -K _vault_profiles vsp vgp

# vault prompt
function vault_prompt_info() {
  [[ -z $VAULT_PROFILE ]] && return
  echo "${ZSH_THEME_VAULT_PREFIX:=<VAULT:}${VAULT_PROFILE}:${VAULT_DEFAULT_REGION}${ZSH_THEME_vault_SUFFIX:=>}"
}

if [ "$SHOW_vault_PROMPT" != false ]; then
  RPROMPT='$(vault_prompt_info)'"$RPROMPT"
fi
