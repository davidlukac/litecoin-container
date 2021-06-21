# Litecoin Docker container

Very simple Docker container running Litecoin daemon.


## Deployment to Kubernetes cluster with Kustomize.io

Repository contains simple stateful set example of a deployment into a Kubernetes cluster.

Prerequisites:
- `litecoin` namespace created,
- `litecoin` secret created, containing `litecoin.conf` key with contents of the config file, including sensitive
  information like RPC auth,
- 2x `pv`s created, with storage class of `host-storage` for persistence,
- built `litecoin` image is available to the cluster,   
- `kubectl` installed and authenticated against the cluster.

For examples of creation of these resources with Terraform, please visit `litecoin-tf` repository. 

To deploy to the cluster run

```shell
kubectl apply -k deploy
# Get stateful set info:
kubectl describe statefulset litecoin -n litecoin
# Watch pod logs:
kubectl logs litecoin-0 -n litecoin -f
```
