# Giant Swarm Step for Wercker
This step enables deployments to Giant Swarm when code is committed to a Wercker and Swarm enabled repository.

You may use the step by including the following in your *wercker.yml* file, which includes the pushing of the container to the registry:

```
deploy:
  box: python:2.7-slim
  steps:
    - internal/docker-push:
        username: $gsuser 
        password: $gspass
        tag: latest
        cmd: /pipeline/source/entrypoint.sh
        ports: "5000"
        repository: registry.giantswarm.io/$gsuser/swacker
        registry: https://registry.giantswarm.io

    - kordless/giantswarm:
        env: $gsenv
        token: $gstoken
        opts: --var=gsuser=$gsuser
        update: swacker/swacker-service/flask
```

Please note you will need to create a deploy target in your account on wercker.com.


