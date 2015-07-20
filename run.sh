#!/bin/sh
# get the token by calling `swarm login` with user/pass
$WERCKER_STEP_ROOT/swarm login -p $WERCKER_GIANTSWARM_PASS $WERCKER_GIANTSWARM_USER

# If we have an environment set, switch to it
if [ -n "$WERCKER_GIANTSWARM_ENV" ]; then
  echo $WERCKER_STEP_ROOT/swarm env $WERCKER_GIANTSWARM_ENV
  $WERCKER_STEP_ROOT/swarm env $WERCKER_GIANTSWARM_ENV
fi

timer1=$(date +"%s")
# If we have a swarm.json then try to create and start the app
if [ -f "swarm.json" ]; then
  info "found a swarm.json, attempting to swarm up"
  $WERCKER_STEP_ROOT/swarm up $WERCKER_GIANTSWARM_OPTS
fi
timer2=$(date +"%s")
delta=$(($timer2-$timer1))

# only do the update if the time took to run swarm up was less than 6 seconds
if [ $delta -lt 6 ]; then
  $WERCKER_STEP_ROOT/swarm update $WERCKER_GIANTSWARM_UPDATE
fi

