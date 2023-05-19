# fantastic-happiness

This repo holds ArgoCD applications used during NDK EA.

## Install ArgoCD

Install ArgoCD in `argocd` namespace :
```bash
k create namespace argocd

k apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
```

Update argocd-cm ConfigMap to exclude CiliumIdentity CR to avoid out-of-sync issues :
```yaml
# add this in argocd-cm
data:
  resource.exclusions: |
    - apiGroups:
      - cilium.io
      kinds:
      - CiliumIdentity
      clusters:
      - "*"
```


Install ArgoCD CLI tool :
```bash
brew install argocd
```

Access ArgoCD via portforward :
```bash
k port-forward svc/argocd-server -n argocd 8080:8080
```

Register a second cluster :
```bash
# List contexts
k config get-contexts -o name

# Register DR cluster with argocd-cli
argocd cluster add target
```