#!/bin/bash
# This script creates a Cloudflare tunnel and generates a Kubernetes secret with the tunnel credentials.

# Set the name of the tunnel
TUNNEL_NAME="example-tunnel"

# Log in to Cloudflare tunnel
echo "Logging in to Cloudflare tunnel..."
cloudflared tunnel login

# Create the Cloudflare tunnel with the specified name
echo "Creating Cloudflare tunnel: $TUNNEL_NAME..."
cloudflared tunnel create $TUNNEL_NAME

# Get the home directory of the current user
HOME_DIR=$(eval echo ~$USER)

# Get the tunnel ID for the specified tunnel name
echo "Getting tunnel ID..."
TUNNEL_ID=$(cloudflared tunnel list | grep $TUNNEL_NAME | awk '{print $1}')
echo "Tunnel ID: $TUNNEL_ID"

# Create a Kubernetes secret with the tunnel credentials
echo "Creating Kubernetes secret..."
kubectl -n cloudflare --dry-run=client create secret generic $TUNNEL_NAME-credentials \
--from-file=credentials.json=$HOME_DIR/.cloudflared/${TUNNEL_ID}.json -o yaml > $TUNNEL_NAME-credentials.yaml
echo "Kubernetes secret created: $TUNNEL_NAME-credentials.yaml"
