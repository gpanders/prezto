#
# Fuzzy file finder
#
# Authors:
#   Greg Anders <greg.p.anders@gmail.com>
#

# Return if requirements are not found.
if [ ! -f ~/.fzf.zsh ]; then
  return 1
fi

source ~/.fzf.zsh

# Use ag if available
if (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND="ag --hidden --ignore .git -g ''"
  _fzf_compgen_path() {
    ag --hidden --ignore .git -g '' "$1"
  }
else
  export FZF_DEFAULT_COMMAND="find . -path '*/\.*' -prune -o -type f -print -o -type l -print | sed s/^..//"
fi

# Use git ls-tree for speed - if it fails (i.e. not in a git directory) default
# to $FZF_DEFAULT_COMMAND
export FZF_DEFAULT_COMMAND="(git ls-tree -r --name-only HEAD || $FZF_DEFAULT_COMMAND) 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--inline-info"

# If fasd is loaded, pipe output to fzf
# Note that the `fzf-tmux` command works regardless of whether or not the user is
# in a tmux session. If no tmux session is detected, it acts just like `fzf`
if zstyle -t ':prezto:module:fasd' loaded; then
  unalias j 2>/dev/null
  fzf_cd() {
    local dir
    dir="$(fasd -Rdl "$1" | fzf-tmux -1 -0 --no-sort +m)" && cd "${dir}" || return 1
  }
  alias j='fzf_cd'
fi

