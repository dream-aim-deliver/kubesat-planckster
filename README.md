# kubesat-planckster
## Initialize a new cluster

[Read More](https://fluxcd.io/flux/installation/configuration/boostrap-customization/)

```bash
mkdir -p clusters/my-cluster/flux-system
touch clusters/my-cluster/flux-system/gotk-components.yaml \
    clusters/my-cluster/flux-system/gotk-sync.yaml \
    clusters/my-cluster/flux-system/kustomization.yaml
```

Generate a Github Personal Access Token

```bash
export GITHUB_TOKEN=<gh-token>
```

Install Flux components into the cluster

```bash
kubectl create ns flux-system
flux bootstrap github --token-auth --owner=dream-aim-deliver --repository=kubesat-planckster --branch=main --path=clusters/my-cluster
```

