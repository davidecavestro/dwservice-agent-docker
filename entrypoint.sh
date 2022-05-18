#!/bin/bash
set -e

should_create_config=true

CFG="${CFG_FOLDER}/config.json"

if  [ -f "$CFG" ]; then
  echo "Existing config file detected"
  cfg_type=$(jq type $CFG)

  # Detect existing config
  if [ "$cfg_type" = '"object"' ] ; then

    cfg_has_key=$(cat $CFG | jq 'has("key")')
    cfg_has_password=$(cat $CFG | jq 'has("password")')

    if [ "$cfg_has_key" = true ] && [ "$cfg_has_password" = true ] ; then
      echo "Config file seems ok"
      should_create_config=false
    fi
  fi
fi

if [ "$should_create_config" = true ]; then
  # Create config
  echo "Generating config"
  rm -f "$CFG"
  printf "$AGENT_CODE\n" | python3 /app/make/create_config.py
  echo "Moving generated file to config folder"
  mv /app/core/config.json $CFG
fi

echo "Linking config file"
ln -s $CFG /app/core/config.json

# Launch agent
echo "Launching agent"
python3 /app/core/agent.py
