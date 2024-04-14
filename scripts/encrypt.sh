#!/bin/bash

# Directory where the files are located
directory="releases/production/secrets"

# Pattern to match
pattern="*.yaml"

# Loop over each file in the directory that matches the pattern
for file in "$directory"/$pattern
do
  echo $file
  # Check if the file name is "kustomization.yaml"
  if [ "$(basename "$file")" = "kustomization.yaml" ]; then
    echo "Skipping kustomization.yaml"
    continue
  fi
  # Encrypt the file and save the output to a new file
  sops --encrypt --in-place --age=age19xkz3rtp7pu0vzxmzqq2qd5reh0e4v328764re7vtj547yxls3zqgv6mp3 \
      --encrypted-regex '^(data|stringData)$'  "$file"
done