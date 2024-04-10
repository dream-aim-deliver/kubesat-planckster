#!/bin/bash

# Check if the path of the secret is provided as an argument
if [ $# -eq 0 ]; then
    echo "Please provide the path of the secret as an argument."
    exit 1
fi

# Extract the secret name from the provided path
secret_path=$1
secret_name=$(basename "$secret_path" .yaml)

# Generate the sealed secret YAML file
kubeseal --format=yaml --cert=pub-sealed-secrets.pem < "$secret_path" > "$(dirname "$secret_path")/$secret_name-sealed.yaml"

# Delete the original secret file
rm "$secret_path"

echo "Sealed secret file generated: $secret_name-sealed.yaml"
