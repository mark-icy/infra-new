#!/bin/bash

read -p "Enter the namespace: " namespace
read -p "Enter the name of the secret: " secret_name

read -p "Enter the username: " username
read -sp "Enter the password: " password
echo

kubectl create secret generic "$secret_name" \
  --namespace "$namespace" \
  --dry-run=client \
  --from-literal="username=$username" \
  --from-literal="password=$password" \
  -o json \
  | kubeseal --cert ../secrets/mytls.crt \
  > ../secrets/sealedsecret-"$secret_name".yaml

echo "Sealed secret created: sealedsecret-$secret_name.yaml"

