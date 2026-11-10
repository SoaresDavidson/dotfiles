# =========================================================
# Plugins
# =========================================================

# ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"
#
# _zplugin_load() {
#   local plugin_path="${ZPLUGINDIR}/${2}"
#   if [[ ! -d "$plugin_path" ]]; then
#     mkdir -p "$ZPLUGINDIR"
#     echo "Installing ${2}..."
#     git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
#       || { echo "ERROR: failed to install ${2}" >&2; return 1; }
#   fi
#   source "${plugin_path}/${2}.plugin.zsh"
# }
#
# zplugin-update() {
#   local dir
#   for dir in "${ZPLUGINDIR}"/*/; do
#     echo "Updating ${dir:t}..."
#     git -C "$dir" pull --ff-only
#   done
# }
#
# _zplugin_load zsh-users zsh-autosuggestions
# _zplugin_load zsh-users zsh-history-substring-search
# _zplugin_load jeffreytse zsh-vi-mode
# _zplugin_load zdharma-continuum fast-syntax-highlighting
#
#



# =========================================================
# Plugins via Zinit
# =========================================================
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light jeffreytse/zsh-vi-mode
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light Aloxaf/fzf-tab
