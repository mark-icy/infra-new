#!/bin/bash

read -p "Enter the path to the public key file: " public_key_path
read -p "Enter the path to the private key file: " private_key_path

kubectl -n sealed-secrets create secret tls my-own-certs \
  --cert="$public_key_path" --key="$private_key_path"

kubectl -n sealed-secrets label secret my-own-certs \
  sealedsecrets.bitnami.com/sealed-secrets-key=active

kubectl rollout restart -n sealed-secrets deployment sealed-secrets

