#!/bin/bash

if [ ! -f /opt/nodebb/.stamp_installed ];then
  echo "creating ssmtp configuration"
  envsubst < /etc/ssmtp/ssmtp.conf.template > /etc/ssmtp/ssmtp.conf || (echo "Unable to create ssmtp configuration" && exit 1)
  echo "creating nodebb config.json"
  envsubst < /opt/nodebb/config.json.template > /opt/nodebb/config.json || (echo "Unable to create nodebb config.json" && exit 1)
  for module in ${NODEBB_PLUGINLIST};do
    echo "installing $module"
    npm install "$module" || (echo "Unable to install $module" && exit 1)
    moduleToActivate="${moduleToActivate}, \"`echo $module | cut -f1 -d'@'`\""
  done
  IFS=$OIFS
  node app.js --setup "{\"admin:username\":\"${ADMIN_USERNAME}\",\"admin:password\":\"${ADMIN_PASSWORD}\",\"admin:password:confirm\":\"${ADMIN_PASSWORD}\",\"admin:email\":\"${ADMIN_EMAIL}\"}" --defaultPlugins "[\"nodebb-plugin-composer-default\",\"nodebb-plugin-markdown\",\"nodebb-plugin-mentions\",\"nodebb-widget-essentials\",\"nodebb-rewards-essentials\",\"nodebb-plugin-soundpack-default\",\"nodebb-plugin-emoji-extended\",\"nodebb-plugin-emoji-one\",\"nodebb-plugin-dbsearch\",\"nodebb-plugin-spam-be-gone\"${moduleToActivate}]" || (echo "Unable to install nodebb" && exit 1) 
  # TODO how to remove that (pr on nodebb install.js ?)
  sed -i 's/    }/    },"socket.io": { "transports": ["websocket"]}/' config.json || (echo "Unable to patch config.json" && exit 1)
  touch /opt/nodebb/.stamp_installed
fi

cd /opt/nodebb
./nodebb start
