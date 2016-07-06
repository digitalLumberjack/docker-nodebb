#!/bin/bash

if [ ! -f /opt/nodebb/.stamp_installed ];then
  echo "creating ssmtp configuration"
  envsubst < /etc/ssmtp/ssmtp.conf.template > /etc/ssmtp/ssmtp.conf 
  [[ "$?" != "0" ]] && echo "Unable to create ssmtp configuration" && exit 1
  echo "creating nodebb config.json"
  envsubst < /opt/nodebb/config.json.template > /opt/nodebb/config.json 
  [[ "$?" != "0" ]] && echo "Unable to create nodebb config.json" && exit 1
  touch /opt/nodebb/.stamp_installed
fi

cd /opt/nodebb
node app.js --setup "{\"admin:username\":\"${ADMIN_USERNAME}\",\"admin:password\":\"${ADMIN_PASSWORD}\",\"admin:password:confirm\":\"${ADMIN_PASSWORD}\",\"admin:email\":\"${ADMIN_EMAIL}\"}"
[[ "$?" != "0" ]] && echo "Unable to install nodebb" && exit 1
./nodebb start
