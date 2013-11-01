#!/bin/bash

__docker_ip() {
  sudo docker inspect $1 | json.rb -d '[0]["NetworkSettings"]["IPAddress"]'
}

__docker_pid() {
  sudo docker inspect $@ | json.rb -d '[0]["State"]["Pid"]'
}

case "$1" in
  pid)
    shift
    __docker_pid $@
  ;;
  ip)
    shift
    __docker_ip $@
  ;;
  openports)
    shift
    sudo nmap -sT $(__docker_ip $@)
  ;;
  signal)
    shift
    PID=$(__docker_pid $1)
    sudo kill -$2 $PID
  ;;
  stop|kill)
    echo "export ID=$(sudo docker $@)" > ~/.docker_vars
  ;;
  run)
    for i in $@; do
      if [[ "${i}" == "-i" ]]; then
        INTERACTIVE=true
        CMD="sudo docker $@"
        /bin/bash -c "$CMD"
      fi
    done
    if [[ "$INTERACTIVE" != "true" ]]; then
      echo "export ID=$(sudo docker $@)" > ~/.docker_vars
    fi
  ;;
  rootfs)
    shift
    echo "/var/lib/docker/containers/$(sudo docker inspect $@ | json.rb -d '[0]["ID"]')/rootfs"
  ;;
  *)
    sudo docker $@
  ;;
esac
