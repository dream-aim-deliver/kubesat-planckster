#!/bin/bash
# This script creates a Cloudflare tunnel and generates a Kubernetes secret with the tunnel credentials.

# Set the name of the tunnel
TUNNEL_NAME="$1"

# Check if tunnel name is provided
if [ -z "$TUNNEL_NAME" ]; then
    echo "Please provide a tunnel name."
    echo "Usage: $0 <tunnel_name>"
    exit 1
fi

# Check if tunnel name ends with "-tunnel"
if [[ "$TUNNEL_NAME" == *"-tunnel" ]]; then
    echo "Invalid tunnel name. Tunnel name cannot end with '-tunnel'."
    exit 1
fi
TUNNEL_FULL_NAME="$TUNNEL_NAME-tunnel"

# Log in to Cloudflare tunnel
echo "Logging in to Cloudflare tunnel..."
cloudflared tunnel login

# Create the Cloudflare tunnel with the specified name
echo "Creating Cloudflare tunnel: $TUNNEL_FULL_NAME..."
cloudflared tunnel create $TUNNEL_FULL_NAME

# Create a DNS record for the tunnel
echo "Creating DNS record for the tunnel. $TUNNEL_NAME.devmaany.com"
cloudflared tunnel route dns $TUNNEL_FULL_NAME $TUNNEL_NAME.devmaany.com
# Get the home directory of the current user
HOME_DIR=$(eval echo ~$USER)

# Get the tunnel ID for the specified tunnel name
echo "Getting tunnel ID..."
TUNNEL_ID=$(cloudflared tunnel list | grep $TUNNEL_FULL_NAME | awk '{print $1}')
echo "Tunnel ID: $TUNNEL_ID"

# Create a Kubernetes secret with the tunnel credentials
echo "Creating Kubernetes secret..."
kubectl -n cloudflare --dry-run=client create secret generic $TUNNEL_FULL_NAME-credentials \
--from-file=credentials.json=$HOME_DIR/.cloudflared/${TUNNEL_ID}.json -o yaml > $TUNNEL_FULL_NAME-credentials.yaml
echo "Kubernetes secret created: $TUNNEL_FULL_NAME-credentials.yaml"

# Move the secret file to releases/production/secrets directory
echo "Moving secret file to releases/production/secrets directory."
mv $TUNNEL_FULL_NAME-credentials.yaml releases/production/secrets

echo "Please export this secret in the releases/production/secrets/kustomization.yaml file."

# Create the tunnel manifests
mkdir -p releases/production/cloudflared/$TUNNEL_FULL_NAME

# Copy the manifests in sda-tunnel directory to the releases/production/cloudflared/$TUNNEL_FULL_NAME directory
echo "Create the sample tunnel manifests in the releases/production/cloudflared/$TUNNEL_FULL_NAME directory."
cp -r releases/production/cloudflared/sda-tunnel/* releases/production/cloudflared/$TUNNEL_FULL_NAME

echo "Please update the tunnel manifests in the releases/production/cloudflared/$TUNNEL_FULL_NAME directory."