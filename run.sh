#!/bin/sh
# get the token by calling `swarm login` with user/pass
$WERCKER_STEP_ROOT/swarm login -p $WERCKER_GIANTSWARM_PASS $WERCKER_GIANTSWARM_USER

# If we have an environment set, switch to it
if [ -n "$WERCKER_GIANTSWARM_ENV" ]; then
  echo $WERCKER_STEP_ROOT/swarm env $WERCKER_GIANTSWARM_ENV
  $WERCKER_STEP_ROOT/swarm env $WERCKER_GIANTSWARM_ENV
fi

# If we have a swarm.json then try to create and start the app
if [ -f "swarm.json" ]; then
  # check the application status
  if [ "$( $WERCKER_STEP_ROOT/swarm status swacker |grep -c -e '\sup$' )" -ne 0 ]; then
    # running, so we update
    echo $WERCKER_STEP_ROOT/swarm update $WERCKER_GIANTSWARM_UPDATE
    $WERCKER_STEP_ROOT/swarm update $WERCKER_GIANTSWARM_UPDATE
  else
    # not running, so we swarm up
    echo $WERCKER_STEP_ROOT/swarm up $WERCKER_GIANTSWARM_OPTS
    $WERCKER_STEP_ROOT/swarm up $WERCKER_GIANTSWARM_OPTS
  fi
fi
