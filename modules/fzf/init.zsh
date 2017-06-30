#
# Fuzzy file finder
#
# Authors:
#   Greg Anders <greg.p.anders@gmail.com>
#

# Add manually installed fzf to path
if [[ -s "$HOME/.fzf/bin/fzf" ]]; then
  path=("$HOME/.fzf/bin" $path)
fi

if (( ! $+commands[fzf] )); then
  return 1
fi

if zstyle -t ':prezto:module:fzf' key-bindings; then
  source "${0:h}/external/shell/key-bindings.zsh"
fi

if zstyle -t ':prezto:module:fzf' completion; then
  [[ $- == *i* ]] && source "${0:h}/external/shell/completion.zsh" 2>/dev/null
fi

# Set height of fzf results
zstyle -s ':prezto:module:fzf' height FZF_HEIGHT

# Open fzf in a tmux pane if using tmux
if zstyle -t ':prezto:module:fzf' tmux && [ -n "$TMUX_PANE" ]; then
  export FZF_TMUX=1
  export FZF_TMUX_HEIGHT=${FZF_HEIGHT:-40%}
  alias fzf="fzf-tmux -d${FZF_TMUX_HEIGHT}"
else
  export FZF_TMUX=0
  if [ ! -z "$FZF_HEIGHT" ]; then
    export FZF_DEFAULT_OPTS="--height ${FZF_HEIGHT} --reverse"
  fi
fi

__fzf_prog() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ] \
    && echo "fzf-tmux -d${FZF_TMUX_HEIGHT}" || echo "fzf"
}

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
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --inline-info"

# If fasd is loaded, pipe output to fzf
# Note that the `fzf-tmux` command works regardless of whether or not the user is
# in a tmux session. If no tmux session is detected, it acts just like `fzf`
if zstyle -t ':prezto:module:fasd' loaded; then
  unalias j 2>/dev/null
  __fzf_cd() {
    local dir fzf
    fzf=$(__fzf_prog)
    dir="$(fasd -Rdl "$1" | ${=fzf} -1 -0 --no-sort +m)" && cd "${dir}" || return 1
  }
  alias j='__fzf_cd'
fi
