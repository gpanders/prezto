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

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS="--inline-info"

# Change working directory interactively
unalias j 2>/dev/null
j() {
  if [[ -z "$*" ]]; then
    cd "$(_j -l 2>&1 | fzf-tmux +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _last_j_args="$@"
    _j "$@"
  fi
}

# Open files with the default editor
_fzf_e() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${(z)VISUAL:-${(z)EDITOR}} "${files[@]}"
}

alias e=_fzf_e
