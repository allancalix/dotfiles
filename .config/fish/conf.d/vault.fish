lib::check_cmd_exists vault

abbr -a v 'vault'

if test -e "$HOME/.vault-token"
  setenv VAULT_TOKEN (cat $HOME/.vault-token)
end
