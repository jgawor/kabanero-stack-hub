# kabanero-stack-hub

## Step 1

Run `./build-index.sh <REGISTRY>` for example, `./build-index.sh myregistry:5000`. This command needs to be executed on a machine that has access to the internet and access to the image registry. It has the `oc` tool and `docker` installed.

## Step 2

Run `./deploy-index.sh <REGISTRY>` for example, `./deploy-index.sh myregistry:5000`. This command needs to be executed on a machine that just has access to the OCP cluster. It requires the `oc` tool be installed and connection to the cluster.


Stack Hub details in https://github.com/kabanero-io/kabanero-stack-hub/blob/master/README.md.
