# Giant Swarm Step for Wercker
This step enables deployments to Giant Swarm when code is committed to a Wercker and Swarm enabled repository.

[![wercker status](https://app.wercker.com/status/4389a232f27da0dbce866ce6d6f9a9e1/m "wercker status")](https://app.wercker.com/project/bykey/4389a232f27da0dbce866ce6d6f9a9e1)

You may use the step by including the following in your *wercker.yml* file, which includes the pushing of the container to the registry:

```
deploy:
  box: python:2.7-slim
  steps:
    - internal/docker-push:
        username: $user 
        password: $pass
        tag: latest
        cmd: /pipeline/source/entrypoint.sh
        ports: "5000"
        repository: registry.giantswarm.io/$user/swacker
        registry: https://registry.giantswarm.io

    - kordless/giantswarm:
        env: $env
        user: $user
        pass: $pass
        opts: --var=user=$user
        update: swacker/swacker-service/flask
```

Please note you will need to create a deploy target in your account on wercker.com, setting the variables `env`, `user`, and `pass` in the deploy step. There is a video you can watch on the [Swacker repo](https://github.com/giantswarm/swacker/) that shows how to do this.


