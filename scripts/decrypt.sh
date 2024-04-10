#!/bin/bash

# Directory where the files are located
directory="releases/integration/webuiint-includes"

# Pattern to match
pattern="*.yaml"

# Loop over each file in the directory that matches the pattern
for file in "$directory"/$pattern
do
  echo $file
  # Decrypt the file and save the output to a new file
  sops --decrypt --in-place "$file"
done