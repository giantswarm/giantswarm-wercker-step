#!/bin/sh
swarm=$WERCKER_STEP_ROOT/swarm

# Set up the token
mkdir -p $HOME/.swarm
echo $WERCKER_GIANTSWARM_TOKEN > $HOME/.swarm/token

# If we have an environment set, switch to it
if [ -n "$WERCKER_GIANTSWARM_ENV" ]; then
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
