#!/usr/bin/env bash
# Setup terminal environment on a remote Debian-based machine (Pi, servidor, VM):
# bat, eza, fzf, ripgrep, zoxide, starship, neovim(LazyVim), zsh + dotfiles
set -euo pipefail

ARCH=$(uname -m)
case "$ARCH" in
  aarch64) GH_ARCH="aarch64" ;;
  armv7l)  GH_ARCH="armv7"   ;;
  x86_64)  GH_ARCH="x86_64"  ;;
  *) echo "Arch nao suportada: $ARCH"; exit 1 ;;
esac
echo "Arch detectada: $ARCH -> $GH_ARCH"

sudo apt update
sudo apt install -y zsh git tmux stow ripgrep fzf curl build-essential

# neovim via apt costuma ser antigo; usa tar.gz oficial (LazyVim precisa nvim >= 0.9)
# nomes de asset da neovim usam "arm64", nao "aarch64"; tar.gz evita depender de libfuse2 (appimage)
NVIM_ARCH="arm64"
[[ "$ARCH" == "x86_64" ]] && NVIM_ARCH="x86_64"
if ! command -v nvim >/dev/null || [[ "$(nvim --version | head -1)" < "NVIM v0.9" ]]; then
  echo "Instalando neovim via tar.gz (${NVIM_ARCH})..."
  curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo mv /opt/nvim-linux-${NVIM_ARCH} /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
fi

# bat: apt empacota como batcat
if ! command -v bat >/dev/null; then
  sudo apt install -y bat || true
  if command -v batcat >/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf "$(command -v batcat)" ~/.local/bin/bat
  fi
fi

# eza: geralmente ausente no Debian estavel -> binario do release
if ! command -v eza >/dev/null; then
  echo "Instalando eza via release binario..."
  curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_${GH_ARCH}-unknown-linux-gnu.tar.gz"
  tar xzf /tmp/eza.tar.gz -C /tmp
  sudo mv /tmp/eza /usr/local/bin/
fi

# zoxide: apt do Debian estavel costuma ter versao antiga/ausente -> instalador oficial
if ! command -v zoxide >/dev/null; then
  echo "Instalando zoxide..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# starship: idem, instalador oficial garante versao atual
if ! command -v starship >/dev/null; then
  echo "Instalando starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# dotfiles
if [[ ! -d ~/.dotfiles ]]; then
  echo "Clonando dotfiles..."
  git clone https://github.com/SoaresDavidson/dotfiles.git ~/.dotfiles
fi

mkdir -p ~/.config
stow -v -d ~/.dotfiles/.config -t ~/.config zsh nvim tmux 2>&1 || echo "Stow: resolva conflitos de arquivo existente manualmente (backup antes)."

# starship.toml fica solto em .config (nao em subpasta), stow nao cobre -> link direto
ln -sf ~/.dotfiles/.config/starship.toml ~/.config/starship.toml

# zsh real config fica em ~/.config/zsh, mas zsh so acha isso se ZDOTDIR
# for setado ANTES, via ~/.zshenv na raiz do HOME (nao stowed).
if [[ ! -f ~/.zshenv ]] || ! grep -q "ZDOTDIR" ~/.zshenv; then
  echo 'export ZDOTDIR="$HOME/.config/zsh"' >> ~/.zshenv
  echo "~/.zshenv criado com ZDOTDIR apontando pra ~/.config/zsh"
fi

chsh -s "$(command -v zsh)"

echo "Feito. Reconecte via SSH (ou 'exec zsh') pra aplicar o shell novo."
echo "Na primeira abertura do nvim, LazyVim vai instalar plugins automaticamente."
