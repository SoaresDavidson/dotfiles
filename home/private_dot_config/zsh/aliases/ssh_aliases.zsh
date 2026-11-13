na_rede_local(){
  [[ -n $HOME_GW_MAC ]] || return 1
  local gw=$(ip -4 route show default | awk '{print $3; exit}')
  [[ -n $gw ]] && ip neigh show "$gw" | grep -qi "$HOME_GW_MAC"
}
jjs(){
  if na_rede_local; then
    ssh davi@jessejamesserver.local "$@"
  else
    ssh davi@jessejamesserver "$@"
  fi
}

