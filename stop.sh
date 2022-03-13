#!/bin/bash
HOME_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

killall ngrok
cd "$HOME_DIR"/postfacto/deployment/helm
# helm delete app
rm -rf Chart.yaml.bak postfacto-0.5.0-beta.tgz charts/*
# kubectl delete pvc --all
cd "$HOME_DIR" && rm -rf postfacto
minikube stop && minikube delete --all
