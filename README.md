# kubesat-planckster

## Kernel Planckster MinIO Configuration
After flux has initially reconciled this repository with you cluster, the kernel planckster pods will not start. You need to go to the MinIO console and generate a new access key and secret key. You can save the credentials in a Kubernetes secret.

Create a new file called `minio-secret-patch.yaml` with the following content:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: kp-minio-credentials
  namespace: sda
type: Opaque
stringData:
  accesskey: <accessKey>
  secretkey: <secretKey>
```

You can then apply the secret to the cluster with the following command:

```bash
kubectl apply -f minio-secret-patch.yaml
```

## Exposing services via Cloudflare
To expose a new serivce from the cluster to the internet, you need to create a new Cloudflare tunnel you can use the `scripts/cloudflare-tunnel.sh` script to create a new tunnel. 

```bash
./scripts/cloudflare-tunnel.sh <tunnel-name>
```

This script will generate a secret in `/releases/production/secrets` directory cotnaining the tunnel credentials.

Please make sure you encrypt the secret before committing it to the repository.

This script also generates `releases/production/cloudflared/$TUNNEL_NAME` directory with sample manifests. Please update the tunnel name and the route in the config map and the deployment manifests.

DO NOT FORGET TO EXPOSE THE SECRET AND THE MANIFESTS in the corresponding `kustomization.yaml` files.