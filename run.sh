#!/bin/sh
# do some setup
sudo apt-get update -y 
sudo apt-get install -y curl

# grab jq
wget http://stedolan.github.io/jq/download/linux32/jq

# set swarm
swarm=$WERCKER_STEP_ROOT/swarm

# get the token by calling the API
mkdir -p $HOME/.swarm
curl -sS \
    -H "Content-Type: application/json" \
    -X POST \
    --data '{"password":"'"$(echo -n $WERCKER_GIANTSWARM_PASS | base64)"'"}' \
    https://api.giantswarm.io/v1/user/$WERCKER_GIANTSWARM_USER/login \
    | jq '.data.Id' > $HOME/.swarm/token > $HOME/.swarm

# If we have an environment set, switch to it
if [ -n "$WERCKER_GIANTSWARM_ENV" ]; then
  echo $swarm env $WERCKER_GIANTSWARM_ENV
  $swarm env $WERCKER_GIANTSWARM_ENV
fi

# If we have a swarm.json then try to create and start the app
if [ -f "swarm.json" ]; then
  info "found a swarm.json, attempting to swarm up"
  $swarm up $WERCKER_GIANTSWARM_OPTS
fi

# If we set a component to update, update it
if [ -n "$WERCKER_GIANTSWARM_UPDATE" ]; then
  $swarm update $WERCKER_GIANTSWARM_UPDATE
fi
