#!/bin/bash -e

IMAGE_REGISTRY=$1

if [ -z "$IMAGE_ORG" ]; then
    export IMAGE_ORG=kabanero
fi
NGINX_IMAGE_NAME=kabanero-index

if [ -z "$IMAGE_REGISTRY" ]; then
    echo "Usage: $0 IMAGE_REGISTRY"
    exit 1
fi

sed -i "s|image-org:.*|image-org: $IMAGE_ORG|" config/default_kabanero_config.yaml
sed -i "s|image-registry:.*|image-registry: $IMAGE_REGISTRY|" config/default_kabanero_config.yaml
sed -i "s|nginx-image-name:.*|nginx-image-name: $NGINX_IMAGE_NAME|" config/default_kabanero_config.yaml

# build nginx container
./scripts/hub_build.sh default_kabanero_config.yaml
docker push $IMAGE_REGISTRY/$IMAGE_ORG/$NGINX_IMAGE_NAME

# mirror necessary images
oc image mirror \
   docker.io/kabanero/java-openliberty:0.2.3 $IMAGE_REGISTRY/$IMAGE_ORG/java-openliberty:0.2.3 $IMAGE_REGISTRY/$IMAGE_ORG/java-openliberty:0.2

