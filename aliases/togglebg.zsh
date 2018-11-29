function togglebg() {
  if [[ "$TERMBG" == "dark" ]]; then
    export TERMBG="light"
  else
    export TERMBG="dark"
  fi

  if [ ! -z "$TMUX_PANE" ]; then
    tmux source-file $HOME/.tmux/plugins/tmux-colors-solarized/tmuxcolors-${TERMBG}.conf
  fi

  if [ -f ~/.iterm2/it2setcolor ]; then
    ~/.iterm2/it2setcolor preset "Solarized ${(C)TERMBG}"
  fi
}
