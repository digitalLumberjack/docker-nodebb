#!/bin/bash

cd /opt/nodebb

if [ ! -f /opt/nodebb/.stamp_installed ];then
  echo "creating ssmtp configuration"
  envsubst < /etc/ssmtp/ssmtp.conf.template > /etc/ssmtp/ssmtp.conf || (echo "Unable to create ssmtp configuration" && exit 1)
  echo "creating nodebb config.json"
  envsubst < /opt/nodebb/config.json.template > /opt/nodebb/config.json || (echo "Unable to create nodebb config.json" && exit 1)
  /usr/local/bin/install-plugins.sh ${NODEBB_PLUGINLIST}
  modulesToActivate=`cat /usr/share/modulesToActivate`
  IFS=$OIFS
  node app.js --setup "{\"admin:username\":\"${ADMIN_USERNAME}\",\"admin:password\":\"${ADMIN_PASSWORD}\",\"admin:password:confirm\":\"${ADMIN_PASSWORD}\",\"admin:email\":\"${ADMIN_EMAIL}\"}" --defaultPlugins "[\"nodebb-plugin-composer-default\",\"nodebb-plugin-markdown\",\"nodebb-plugin-mentions\",\"nodebb-widget-essentials\",\"nodebb-rewards-essentials\",\"nodebb-plugin-soundpack-default\",\"nodebb-plugin-emoji-extended\",\"nodebb-plugin-emoji-one\",\"nodebb-plugin-dbsearch\",\"nodebb-plugin-spam-be-gone\"${modulesToActivate}]" || (echo "Unable to install nodebb" && exit 1) 
  # TODO how to remove that (pr on nodebb install.js ?)
  if [[ "${NODEBB_WEBSOCKETONLY}" == "true" ]];then
    sed -i 's/    }/    },"socket.io": { "transports": ["websocket"]}/' config.json || (echo "Unable to patch config.json" && exit 1)
  fi
  touch /opt/nodebb/.stamp_installed
fi

if [[ "${NODEBB_AUTO_UPGRADE}" != "" && "${NODEBB_AUTO_UPGRADE}" != "false" ]];then
  ./nodebb upgrade
fi
./nodebb start
