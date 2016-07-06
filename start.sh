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
node app.js --setup "{\"admin:username\":\"${ADMIN_USERNAME}\",\"admin:password\":\"${ADMIN_PASSWORD}\",\"admin:password:confirm\":\"${ADMIN_PASSWORD}\",\"admin:email\":\"${ADMIN_EMAIL}\"}" --defaultPlugins '["nodebb-plugin-composer-default","nodebb-plugin-markdown","nodebb-plugin-mentions","nodebb-widget-essentials","nodebb-rewards-essentials","nodebb-plugin-soundpack-default","nodebb-plugin-emoji-extended","nodebb-plugin-emoji-one","nodebb-plugin-s3-uploads-updated"]'
[[ "$?" != "0" ]] && echo "Unable to install nodebb" && exit 1
./nodebb start
