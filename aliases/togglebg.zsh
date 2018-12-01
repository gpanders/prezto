function togglebg() {
  if [[ "$TERM_PROGRAM" == iTerm* ]]; then
    if [[ "$TERMBG" == "dark" ]]; then
      export TERMBG="light"
    else
      export TERMBG="dark"
    fi

    if [ ! -z "$TMUX_PANE" ]; then
      tmux source-file $HOME/.tmux/colors/solarized-${TERMBG}.conf
    fi

    if [[ $TERM == screen* ]]; then
      printf "\033Ptmux;\033"
    fi
    printf "\033]"
    printf "1337;SetColors=preset=Solarized %s" "${(C)TERMBG}"
    printf "\a"
    if [[ $TERM == screen* ]]; then
      printf "\033\\"
    fi
  else
    echo "iTerm is required."
  fi
}
