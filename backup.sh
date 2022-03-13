#!/bin/bash
HOME_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

POD_NAME=$(kubectl get pods | grep app-postgresql | grep -o "^\S*")
PASSWORD=$(kubectl get secret app-postgresql -o jsonpath='{.data.postgresql-password}' | base64 -d)
kubectl exec "$POD_NAME" -- bash -c "PGPASSWORD=$PASSWORD pg_dump -U postgres postgres" > "$HOME_DIR"/backup/backup.sql
