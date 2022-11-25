# Vault switcher

Simple zsh plugin that provides a way to switch between vault profiles a la aws-cli.

## Configuration

Install using your favourite zsh plugin manager

credentials file should be kept in `~/.vault/credentials`, yaml formatted like so:

```yaml
profile_1:
  address: https://vault.example.com
  token: s.MY_TOKEN

profile_2:
  address: https://vault-prod.example.com
  token: s.MY_PROD_TOKEN

profile_app_role:
  address: https://vault.example.com
  role_id: { UUID }
  secret_id: { UUID }
```
