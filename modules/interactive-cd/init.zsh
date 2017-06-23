#
# Interactive cd for fzf
#
# Authors:
#   Greg Anders <greg.p.anders@gmail.com>
#

# Return if requirements are not found.
if ! zstyle -t ':prezto:module:fzf' loaded; then
  return 1
fi

source "${0:h}/external/zsh-interactive-cd.plugin.zsh" || return 1

