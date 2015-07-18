#!/bin/sh
# install curl (this sucks a bit)
sudo apt-get update -y
sudo apt-get install curl -y

# get the token by calling the API
mkdir -p $HOME/.swarm; touch $HOME/.swarm/token
curl -sS \
    -H "Content-Type: application/json" \
    -X POST \
    --data '{"password":"'"$(echo -n $WERCKER_GIANTSWARM_PASS | base64)"'"}' \
    https://api.giantswarm.io/v1/user/$WERCKER_GIANTSWARM_USER/login \
    | $WERCKER_STEP_ROOT/jq -r '.data.Id' >> $HOME/.swarm/token

# If we have an environment set, switch to it
if [ -n "$WERCKER_GIANTSWARM_ENV" ]; then
  echo $WERCKER_STEP_ROOT/swarm env $WERCKER_GIANTSWARM_ENV
  $WERCKER_STEP_ROOT/swarm env $WERCKER_GIANTSWARM_ENV
fi

# If we have a swarm.json then try to create and start the app
if [ -f "swarm.json" ]; then
  info "found a swarm.json, attempting to swarm up"
  $WERCKER_STEP_ROOT/swarm up $WERCKER_GIANTSWARM_OPTS
fi

# If we set a component to update, update it
if [ -n "$WERCKER_GIANTSWARM_UPDATE" ]; then
  $WERCKER_STEP_ROOT/swarm update $WERCKER_GIANTSWARM_UPDATE
fi
