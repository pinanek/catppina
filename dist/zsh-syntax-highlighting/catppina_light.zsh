# Catppuccin Latte Theme (for zsh-syntax-highlighting)
#
# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#d8d8da'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[function]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[command]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#186846,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#944600,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#944600'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#944600'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#41599c'
## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#186846'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#186846'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#a72f3a'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#a72f3a'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#a72f3a'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#a72f3a'
## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#765702'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#765702'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#765702'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#984133'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#765702'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#984133'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#765702'
## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#984133'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#303033'
## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#984133'
ZSH_HIGHLIGHT_STYLES[path]='fg=#303033,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#a72f3a,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#303033,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#a72f3a,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#41599c'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#984133'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[default]='fg=#303033'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#303033'
