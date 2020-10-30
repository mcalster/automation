#!/bin/bash
#WATCH_COMMAND=${1}
WATCH_COMMAND="ls -lR /config/.storage"
watch_cmd.sh "ls -lR /etc/nginx | grep .conf$" "sudo service nginx reload"
#COMMAND=${2}
COMMAND=/config/comitter.sh
while true; do 
  watch -d -g "${WATCH_COMMAND}" ${COMMAND} 
  sleep 1 # to allow break script by Ctrl+c
done