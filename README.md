# Quick Postfacto

This allows you to run Postfacto instantly on your local and expose the service to the public using ngrok.

## Requirements

- Docker, Kubernetes, Helm
- Minikube
- Localtunnel / ngrok

## Run

```sh
sh run.sh
```

* Warning: make sure you are looking at the correct Kubernetes context.
* Run localtunnel or ngrok after the app is ready on localhost:8080

### Options

- start: Starts Postfacto container and its DB container, and restores state if `backup/backup.sql` is present.
- backup: Backs up current Postfacto state as `backup.sql` in `/backup` directory.
- stop: Shuts down all running Postfacto related containers and volumes. This will stop minikube altogether. All pods in minikube will be removed.
