#FluxCD

FluxCD is a tool that automatically ensures that the state of a cluster matches the configuration you've supplied in Git. It uses a GitOps approach, applying a desired state model to manage infrastructure and application delivery.

FluxCD operates by continuously monitoring a Git repository for changes and applying them to the cluster. It does this by using a series of custom resources (CRDs) to manage the desired state of the system.

The main CRDs FluxCD uses are:

- GitRepository: Represents a source code repository.
- Kustomization: Represents a deployment of a set of Kubernetes resources.

FluxCD is configured to monitor the Git repository specified in the [terraform configs](https://github.com/mark-icy/infra-new/blob/main/terraform/variables.tf). In our setup, this points to THIS repository.

FluxCD applies changes to the cluster based on the Kustomization resources. Each Kustomization resource specifies a path in the Git repository, and FluxCD applies the Kubernetes resources found at that path.

For example, the [infra-controllers and infra-prereqs Kustomizations](https://github.com/mark-icy/infra-new/blob/main/clusters/dev/infrastructure.yaml):
```
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infra-controllers
  namespace: flux-system
spec:
  interval: 10m0s
  retryInterval: 1m0s
  timeout: 5m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./infrastructure/controllers
  prune: true
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infra-prereqs
  namespace: flux-system
spec:
  dependsOn:
    - name: infra-controllers
  interval: 10m0s
  retryInterval: 1m0s
  timeout: 5m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./infrastructure/prereqs
  prune: true
```
And the [apps Kustomization](https://github.com/mark-icy/infra-new/blob/main/clusters/dev/apps.yaml):
```
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: apps
  namespace: flux-system
spec:
  interval: 1h
  retryInterval: 1m
  timeout: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./apps/dev
  prune: true
```
FluxCD also manages secrets using a similar [Kustomization](https://github.com/mark-icy/infra-new/blob/main/clusters/dev/secrets.yaml):
```
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: secrets
  namespace: flux-system
spec:
  interval: 10m
  retryInterval: 1m
  timeout: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./secrets
  prune: true
```

In summary, FluxCD brings up the cluster infrastructure and apps by continuously monitoring a Git repository for changes to Kubernetes resources and applying them to the cluster. It uses a series of controllers and custom resources to manage this process.