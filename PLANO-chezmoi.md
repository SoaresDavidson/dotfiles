# Plano: segredos, TPM e SSH no chezmoi

Estado atual do repositório (levantado em 2026-11-11):

- `.chezmoiroot` aponta para `home/`; `home/.chezmoi.toml.tmpl` gera `sourceDir` e `mode = "symlink"`.
- Template só no `home/.chezmoiignore` (desktop fica de fora fora do Arch/CachyOS).
- `~/.dotfiles/.env` guarda `GITHUB_PERSONAL_ACCESS_TOKEN` e `GOOGLE_STITCH_API_KEY`. Está no `.gitignore`, com permissão 644, e é carregado por `home/private_dot_config/zsh/dot_zshenv` (linhas 2-6). Não chega a outras máquinas.
- O TPM do tmux não é versionado: `tmux.conf` roda `~/.config/tmux/plugins/tpm/tpm`, que precisa ser clonado à mão.
- Não há nada de `~/.ssh` no repositório. Não há chave GPG no sistema.

Ordem: 1 (age + `.env`), 2 (TPM), 3 (SSH). Cada etapa é um commit separado.

## Etapa 1: criptografar o `.env` com age

Decisão: age, não GPG. Não há chave GPG para reaproveitar, a chave age é um arquivo copiável, o chezmoi traz o age embutido e não depende de `gpg-agent`/pinentry (que costuma falhar por SSH e dentro do tmux).

1. Gerar a chave (só uma vez, na máquina principal):

   ```sh
   mkdir -p ~/.config/chezmoi
   chezmoi age-keygen --output ~/.config/chezmoi/key.txt
   chmod 600 ~/.config/chezmoi/key.txt
   ```

   Anotar a linha `Public key: age1...`.

2. Fazer backup do `key.txt` fora do repositório (gerenciador de senhas ou pendrive). Sem ele, os arquivos `.age` não abrem mais.

3. Editar `home/.chezmoi.toml.tmpl`. `encryption` precisa ficar antes de qualquer seção `[...]`:

   ```toml
   sourceDir = {{ .chezmoi.homeDir | printf "%s/.dotfiles" | quote }}
   mode = "symlink"
   encryption = "age"

   [age]
       identity = {{ .chezmoi.homeDir | printf "%s/.config/chezmoi/key.txt" | quote }}
       recipient = "age1..."
   ```

   O `recipient` é chave pública e pode ir para o repositório.

4. Regenerar a config: `chezmoi init`, depois conferir `cat ~/.config/chezmoi/chezmoi.toml`.

5. Mover o `.env` para dentro do alvo e adicioná-lo criptografado:

   ```sh
   install -m 600 ~/.dotfiles/.env ~/.config/zsh/secrets.env
   chezmoi add --encrypt ~/.config/zsh/secrets.env
   ```

   No repositório deve aparecer `home/private_dot_config/zsh/encrypted_private_secrets.env.age` (se vier sem `private_`, rodar `chezmoi chattr +private ~/.config/zsh/secrets.env`).

6. Trocar o caminho em `home/private_dot_config/zsh/dot_zshenv`:

   ```sh
   if [[ -f "$ZDOTDIR/secrets.env" ]]; then
     set -a
     source "$ZDOTDIR/secrets.env"
     set +a
   fi
   ```

7. Verificar antes do commit:

   ```sh
   chezmoi apply
   zsh -c 'test -n "$GITHUB_PERSONAL_ACCESS_TOKEN" && echo ok'
   head -1 ~/.dotfiles/home/private_dot_config/zsh/encrypted_private_secrets.env.age
   # esperado: -----BEGIN AGE ENCRYPTED FILE-----
   cd ~/.dotfiles && git add -A && git diff --cached | grep -E "ghp_|github_pat_"
   # esperado: nenhuma saída
   ```

8. Só depois que o passo 7 passar: `rm ~/.dotfiles/.env` e remover a linha `.env` do `.gitignore` (ou mantê-la como proteção, não atrapalha).

Observação: no modo symlink, arquivo criptografado vira arquivo comum em `~`. Editar sempre com `chezmoi edit ~/.config/zsh/secrets.env`; editar direto em `~` faz a mudança se perder no próximo `apply`.

## Etapa 2: TPM via `.chezmoiexternal`

1. Criar `home/.chezmoiexternal.toml`:

   ```toml
   [".config/tmux/plugins/tpm"]
       type = "git-repo"
       url = "https://github.com/tmux-plugins/tpm"
       refreshPeriod = "168h"
   ```

2. Testar: `chezmoi apply -v` e `ls ~/.config/tmux/plugins/tpm/tpm`.

3. Dentro do tmux, `prefix + I` instala os outros plugins. Esses continuam fora do chezmoi (o TPM cuida deles).

O zinit fica como está: `plugins.zsh` já se instala sozinho.

## Etapa 3: SSH, uma chave por dispositivo

Decisão: chave privada não entra no repositório, nem criptografada. Cada máquina tem a sua; perda de um dispositivo exige revogar só a chave dele.

Em cada dispositivo:

```sh
ssh-keygen -t ed25519 -C "davi@$(hostnamectl hostname)"   # com passphrase
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostnamectl hostname)"
ssh -T git@github.com
```

Versionar só o que é público, uma vez:

1. `~/.ssh/config`:

   ```
   Host github.com
       User git
       IdentityFile ~/.ssh/id_ed25519
       AddKeysToAgent yes
   ```

2. `~/.ssh/authorized_keys` com o `.pub` de cada dispositivo, um por linha.

3. Adicionar como privados (o prefixo `private_` faz o chezmoi gravar arquivo comum com 600 em vez de symlink, que o `sshd` pode recusar):

   ```sh
   chezmoi add ~/.ssh/config ~/.ssh/authorized_keys
   chezmoi chattr +private ~/.ssh/config ~/.ssh/authorized_keys
   ls -l ~/.ssh   # não pode haver symlink nesses dois
   ```

Ao perder ou aposentar um dispositivo: remover a linha dele com `chezmoi edit ~/.ssh/authorized_keys`, apagar a chave em github.com/settings/keys, commit, `chezmoi update` nas outras máquinas.

O token do `gh` também fica por máquina (`gh auth login`), fora do chezmoi.

## Máquina nova (depois das três etapas)

1. Copiar o `key.txt` para `~/.config/chezmoi/key.txt` e `chmod 600`.
2. `chezmoi init --apply <repo>`. A config sai do `.chezmoi.toml.tmpl`, o `secrets.env` é descriptografado e o TPM é clonado.
3. Gerar a chave SSH do dispositivo e cadastrar no GitHub.
4. Adicionar o `.pub` novo ao `authorized_keys`, commit, push e `chezmoi update` nas demais.

## Fora do escopo por enquanto

- Scripts `run_once_`/`run_onchange_` (pacotes, `chsh`): só se a montagem de máquinas ficar frequente.
- Templates dentro das configs: só quando houver diferença real entre máquinas.
