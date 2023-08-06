kubectl -n sealed-secrets create secret tls my-own-certs \
  --cert="<path to public key>" --key="<path to private key>"
kubectl -n sealed-secrets label secret my-own-certs \
  sealedsecrets.bitnami.com/sealed-secrets-key=active
kubectl rollout restart -n sealed-secrets deployment sealed-secrets
deployment.apps/sealed-secrets restarted
