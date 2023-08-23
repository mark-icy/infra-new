#!/bin/bash

read -p "Enter your Cloudflare API token: " api_token

kubectl create secret generic cloudflare-api-token-secret \
  --namespace cert-manager \
  --dry-run=client \
  --from-literal=api-token="$api_token" -o json \
  | kubeseal --cert ../secrets/mytls.crt \
  > ../secrets/sealedsecret-cloudflare-api-token-secret.yaml
