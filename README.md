# Codezilla

## Work with k8s cluster

### Use particular kubeconfig

```bash
export KUBECONFIG=kubeconfig.yml
```

### Get pods

```bash
kubectl --namespace=codezilla get pods
```

### Run remote iex console

```bash
kubectl exec -it $APP --namespace=codezilla -- bin/app remote
```
