# Powerful but minimal zsh configuration
# Author: Radley E. Sidwell-Lewis
# GitHub: https://www.github.com/radleylewis/zsh
#
# Uses:
#   Plugins:      fast-syntax-highlighting, zsh-autosuggestions,
#                 zsh-history-substring-search, zsh-vi-mode
#   Prompt:       starship
#   Navigation:   zoxide, fzf, fd
#   CLI tools:    eza, bat, nvim, ripgrep
#   Node:         nvm

# =========================================================
# History
# =========================================================
## 1. Arquivo onde o histórico será salvo e os limites de tamanho
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# 2. Opções cruciais para o compartilhamento em tempo real
setopt SHARE_HISTORY       # Sincroniza o histórico entre todas as sessões ativas do Zsh
setopt INC_APPEND_HISTORY  # Salva o comando no arquivo imediatamente após a execução (não espera fechar o terminal)

# 3. Opções extras de limpeza e organização (Recomendado)
setopt HIST_IGNORE_DUPS    # Não salva comandos iguais digitados repetidamente em sequência
setopt HIST_IGNORE_SPACE   # Não salva no histórico comandos que começam com um espaço (útil para digitar senhas)
setopt HIST_REDUCE_BLANKS  # Remove espaços em branco desnecessários antes de salvar
setopt EXTENDED_HISTORY    # Salva também a data, hora e duração da execução de cada comando =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# =========================================================
# Smart directory navigation & lf
# =========================================================

if [[ -r "$HOME/.config/lf/icons" ]]; then
  LF_ICONS=$(tr '\n' ':' < "$HOME/.config/lf/icons")
  export LF_ICONS
fi

# Initialize zoxide
eval "$(zoxide init zsh --cmd cd)"

# =========================================================
# Completion
# =========================================================

# Load completion system
autoload -Uz compinit

# Initialize completion with cached metadata file
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # lowercase input matches upper and lower
zstyle ':completion:' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
# =========================================================
# Fuzzy finder
# =========================================================

eval "$(fzf --zsh)"
# Arch
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi
# =========================================================
# Modular Config Files
# =========================================================

# fzf configuration
source "$ZDOTDIR/fzf.zsh"

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Custom keybindings
source "$ZDOTDIR/bindings.zsh"

# Plugins and plugin manager
source "$ZDOTDIR/plugins.zsh"

# Prompt/theme
source "$ZDOTDIR/prompt.zsh"


# =========================================================
# Node / NVM
# =========================================================
export PATH=/home/davi/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"



# bun completions
[ -s "/home/davi/.bun/_bun" ] && source "/home/davi/.bun/_bun"
