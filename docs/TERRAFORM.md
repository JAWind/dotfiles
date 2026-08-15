# Terraform

Infrastructure-as-code with the **Terraform** CLI (from HashiCorp's Homebrew
tap), the **tflint** linter, and **terraform-ls** in the editor. AWS
authentication reuses the `awscli` already in this setup.

## Install

Installed by the core Brewfile: Terraform from HashiCorp's tap, tflint from
Homebrew core:

```ruby
tap "hashicorp/tap"
brew "hashicorp/tap/terraform"   # Terraform CLI
brew "tflint"                    # linter (homebrew core)
```

Homebrew refuses to load formulae from an untrusted third-party tap, so trust
HashiCorp's once before the first `brew bundle`:

```sh
brew trust hashicorp/tap
```

Then `brew bundle` installs both. Verify:

```sh
terraform version
tflint --version
```

> Terraform is BUSL-licensed. If your organization requires a fully open-source
> tool, [OpenTofu](https://opentofu.org) (`brew install opentofu`, command
> `tofu`) is a drop-in-compatible fork.

## Versions

One version via Homebrew, upgraded with
`brew upgrade hashicorp/tap/terraform`. If projects need different versions,
add `tfenv` (`brew install tfenv`) and a `.terraform-version` file per project —
not set up by default.

## Core workflow

```sh
terraform init        # download providers and modules
terraform fmt         # format .tf files
terraform validate    # check the configuration is valid
terraform plan        # preview changes
terraform apply       # make the changes
terraform destroy     # tear it all down
```

## Linting (tflint)

`tflint` catches provider-specific problems and best-practice issues that
`terraform validate` won't. It runs from the command line:

```sh
tflint --init         # install plugins declared in .tflint.hcl
tflint                # lint the current directory
```

Configure it per project with a `.tflint.hcl` file.

## Editor (Neovim)

- **terraform-ls** — HashiCorp's language server (a Go binary, so it's
  node-free) is installed automatically by Mason and provides completion,
  hover, go-to-definition, validation, and formatting for `.tf` / HCL. See
  [NEOVIM.md → Language servers](NEOVIM.md#language-servers).
- **Treesitter** parsers `terraform` and `hcl` provide highlighting.
- Format via the LSP (`<leader>ca`, or `:lua vim.lsp.buf.format()`) or the CLI
  (`terraform fmt`). Format-on-save is not enabled.
- `tflint` runs from the CLI, not the editor. To get inline tflint diagnostics,
  add a linter bridge such as `nvim-lint` later.

## State & git

Terraform **state must never be committed** — it can contain secrets. The global
gitignore already excludes `.terraform/`, `*.tfstate`, `*.tfstate.*`, the lock
info file, and crash logs. It deliberately **keeps `.terraform.lock.hcl`**,
which you *should* commit (it pins provider versions). Project-specific
`*.tfvars` are left to each repo's own `.gitignore`, since teams differ on
whether those hold secrets.

For anything shared, use a remote backend (e.g. S3 + DynamoDB) instead of local
state.

## Credentials

Terraform authenticates to AWS through the `awscli` in this setup — configure a
profile with `aws configure` (or `aws sso login`), or export credentials in your
shell. Keep secret values in the macOS Keychain via `secrets.zsh` rather than in
`.tf` or `.tfvars` files — see [SECRETS.md](SECRETS.md).

## Quick start

```sh
mkdir infra && cd infra
# write main.tf ...
terraform init
terraform fmt && terraform validate
terraform plan
```
