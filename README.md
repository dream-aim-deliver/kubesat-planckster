# kubesat-planckster

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
