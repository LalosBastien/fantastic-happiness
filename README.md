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

# Gather initial admin password
argocd admin initial-password -n argocd

# Logon argocd
argocd login localhost:8080

# Register DR cluster with argocd-cli
argocd cluster add target
```

# Replication
- Deploy an application to source cluster by adding an umbrella chart and add it to `applicationset/applicationset.yaml`, in our example privatebin
- Deploy ndk chart to **source** cluster
- Deploy ndk-pairing chart to **target** cluster
- Gather kubeconfig from service account created by ndk-pairing chart
```bash
# Gather kubeconfig from ServiceAccount
k view-serviceaccount-kubeconfig target-privatebin-ndk-pairing-replication-sa -n privatebin -o json > kubeconfig/privatebin-kubeconfig.json
```
- Create secret from kubeconfig in **source** cluster
```bash
# Create secret from file
k create secret generic target-kubeconfig-secret -n privatebin --from-file=KUBECONFIG=kubeconfig/privatebin-kubeconfig.json
```
- Add `replicationTarget.yaml` file to the umbrella chart
```yaml
# templates/replicationTarget.yaml
---
apiVersion: dataservices.nutanix.com/v1alpha1
kind: ReplicationTarget
metadata:
  name: target-k8s-cluster
spec:
  targetClusterSecretRef:
    name: target-kubeconfig-secret
    key: KUBECONFIG
```

# Remark
- No cluster-wide custom ressource (not DRY)
- 

