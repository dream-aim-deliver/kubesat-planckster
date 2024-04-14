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

## Creatin a new tunnel/route via Cloudflare
### Create a new tunnel from scratch
To expose a new serivce from the cluster to the internet, you need to create a new Cloudflare tunnel you can use the `scripts/cloudflare-tunnel.sh` script to create a new tunnel. 

```bash
./scripts/cloudflare-tunnel.sh <tunnel-name>
```

This script will generate a secret in `/releases/production/secrets` directory cotnaining the tunnel credentials.

Please make sure you encrypt the secret before committing it to the repository.

DO NOT FORGET TO EXPOSE THE SECRET AND THE MANIFESTS in the corresponding `kustomization.yaml` files.

### Exposing a service
To expose a service, you need to create a new route for the tunnel. You can use the following command to create a new route:

Please update the ingress section of the configuration file in `releases/production/cloudflared/config.yaml` to include the new route.

Also, add a DNS record for every route you wish to configure
```bash
cloudflared tunnel route dns <tunnel-name> <sub-domain>.devmaany.com
```

Push the changes to the repository and the tunnel will be updated automatically.

