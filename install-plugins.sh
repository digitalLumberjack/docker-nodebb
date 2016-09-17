#!/bin/bash
for module in $@;do
  echo "installing $module"
  npm install "$module" || (echo "Unable to install $module" && exit 1)
  modulesToActivate="${modulesToActivate}, \"`echo $module | cut -f1 -d'@'`\""
  if [[ "$module" =~ "nodebb-plugin-ns-custom-fields" ]];then
    echo "patching files for module $module"
    sed -i '/<h2 class="username"><!-- IF !banned -->/a <!-- IMPORT partials\/account\/custom_fields_flex.tpl -->' node_modules/nodebb-theme-persona/templates/account/profile.tpl || (echo "Unable to patch $module" && exit 1)
  fi
  if [[ "$module" =~ "nodebb-plugin-ns-awards" ]];then
    echo "patching files for module $module"
    sed -i '/<h2 class="username"><!-- IF !banned -->/a <!-- IMPORT partials/awards_profile_flex.tpl -->' node_modules/nodebb-theme-persona/templates/account/profile.tpl || (echo "Unable to patch $module" && exit 1)
    sed -i 's|<!-- IMPORT partials/topic/badge.tpl -->|<!-- IMPORT partials/topic/badge.tpl --><!-- IMPORT partials/awards_topic.tpl -->|g' node_modules/nodebb-theme-persona/templates/partials/topic/post.tpl || (echo "Unable to patch $module" && exit 1)
  fi
done
if [[ ! -z ${modulesToActivate} ]];then
  echo "will activate : ${modulesToActivate}"
  echo "${modulesToActivate}" > /usr/share/modulesToActivate
fi
