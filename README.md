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


## Litecoin trading processing scripts


### Shell

The repository contains a simple script calculating hourly average trading prices for given currency pair. The script 
takes a path to the input CSV file and target date in YYYY-MM-DD format as arguments.

Example usage:
```shell
bin/trading-avg.sh resources/gemini_LTCUSD_1hr.csv 2021-06-22
at 23h 00m 00s the average price of LTCUSD was 119.215 with volume of 1981.5865455
at 22h 00m 00s the average price of LTCUSD was 120.56 with volume of 1067.2457715
at 21h 00m 00s the average price of LTCUSD was 120.82 with volume of 2029.6974064
at 20h 00m 00s the average price of LTCUSD was 121.245 with volume of 2424.3213983
...
```


### Python

Python implementation of the same script. 

Example usage:
```shell
poetry run python bin/trading_avg.py resources/gemini_LTCUSD_1hr.csv 2021-06-22
at 23h 00m 00s the average price of LTCUSD was 119.215 with volume of 1981.5865455
at 22h 00m 00s the average price of LTCUSD was 120.560 with volume of 1067.2457715
at 21h 00m 00s the average price of LTCUSD was 120.820 with volume of 2029.6974064
at 20h 00m 00s the average price of LTCUSD was 121.245 with volume of 2424.3213983
...
```

Formal test:
```shell
pylint bin/trading_avg.py
--------------------------------------------------------------------
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
```

#### Prerequisites

- Python 3.6+
