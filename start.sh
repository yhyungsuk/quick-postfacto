#!/bin/bash
HOME_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$HOME_DIR"/print.sh

# minikube setup
read -erp "Allocate minikube memory[2048(MB)]: " minikube_memory
minikube_memory=${minikube_memory:-2048}
read -erp "Allocate minikube cpu[2]: " minikube_cpus
minikube_cpus=${minikube_cpus:-2}
print "Trying to allocate $minikube_memory MB memory and $minikube_cpus CPUs for minikube.\nMake sure you have enough docker resources!"

minikube start --memory "$minikube_memory" --cpus "$minikube_cpus"

# go to Postfacto directory
git clone https://github.com/pivotal/postfacto.git "$HOME_DIR"/postfacto
cd "$HOME_DIR"/postfacto/deployment/helm || exit

# run
sh build.sh && sed -i "" "s|appVersion\: dev|appVersion\: latest|g" Chart.yaml && helm install app .

print "  Go to localhost:8080/admin when accessible\n  Waiting for all pods to be ready..."

sleep 5
while [[ "$(kubectl get pods | grep app-postfacto)" == *0/1* ]]; do
    print "  Still working..."
    sleep 60
done

print "  Done! Pods are now up and running."

# restore backup if it exists
# if not, add new admin user
if [[ -f "$HOME_DIR"/backup/backup.sql ]]; then
    PASSWORD=$(kubectl get secret app-postgresql -o jsonpath='{.data.postgresql-password}' | base64 -d)
    POSTGRES_POD_NAME=$(kubectl get pods | grep app-postgresql | grep -o "^\S*")
    kubectl exec -i "$POSTGRES_POD_NAME" -- bash -c "PGPASSWORD=$PASSWORD psql -U postgres -d postgres" < "$HOME_DIR"/backup/backup.sql
else
    read -erp "Enter admin email: " email_input
    read -erp "Enter admin password: " password_input
    APP_POD_NAME=$(kubectl get pods | grep app-postfacto | grep -o "^\S*")
    kubectl exec "$APP_POD_NAME" -- create-admin-user $email_input $password_input
fi

# inspect pod status
kubectl get pods

# expose
kubectl port-forward service/app-postfacto 8080:80 &
