[![Build Status](https://travis-ci.com/davidlukac/litecoin-container.svg?branch=master)](https://travis-ci.com/davidlukac/litecoin-container)


# Litecoin Docker container

Very simple Docker container running Litecoin daemon.


## CI build and deployment

The Litecoin image is built on Travis CI. The built uses very simple workflow:
- build & test on any branches,
- build, test and deploy to Docker registry on the `master` branch.

Normally the workflow would be more sophisticated - e.g., GitFlow + release types in SemVer suffix + tag + immutable
repository for releases, etc., but for now this is sufficient.


### Build stages

The build has three stages:
1. build - get all necessary binaries, build the Docker image, and it's BOM,
1. test - perform all style and formal tests, check image security,
1. deploy - push the image to the registry.


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


## Alternative Alpine image

The repository container also alternative `alpine.dockerfile` based on the latest Alpine image and `glibc`, which is
smaller and more contained, but has its downfalls in sense of CVE vulnerabilities.
