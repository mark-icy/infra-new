#!/bin/bash

read -p "Enter the namespace: " namespace
read -p "Enter the name of the secret: " secret_name

declare -A data_values

while true; do
    read -p "Enter a key for the data (or press Enter to finish): " key
    if [[ -z "$key" ]]; then
        break
    fi
    
    read -p "Enter the value for $key: " value
    data_values["$key"]="$value"
done

secret_data=""

# Construct the secret data
for key in "${!data_values[@]}"; do
    value="${data_values[$key]}"
    secret_data+="  $key: $(echo -n "$value" | base64)\n"
done

kubectl create secret generic "$secret_name" \
  --namespace "$namespace" \
  --dry-run=client \
  --from-literal="data=$secret_data" -o json \
  | kubeseal --cert ../secrets/mytls.crt \
  > ../secrets/sealedsecret-"$secret_name".yaml

echo "Sealed secret created: sealedsecret-$secret_name.yaml"

