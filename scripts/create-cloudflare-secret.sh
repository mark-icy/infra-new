  kubectl create secret generic cloudflare-api-token-secret \
  --namespace cert-manager \
  --dry-run=client \
  --from-literal=api-token=gobbledegook -o json \
  | kubeseal --cert ../secrets/mytls.crt \
  > ../secrets/sealedsecret-cloudflare-api-token-secret.yaml

