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

CONFIG_YAML=config/default_kabanero_config.yaml
cp $CONFIG_YAML.tpl $CONFIG_YAML
sed -i "s|image-org:.*|image-org: $IMAGE_ORG|" $CONFIG_YAML
sed -i "s|image-registry:.*|image-registry: $IMAGE_REGISTRY|" $CONFIG_YAML
sed -i "s|nginx-image-name:.*|nginx-image-name: $NGINX_IMAGE_NAME|" $CONFIG_YAML

# build nginx container
./scripts/hub_build.sh default_kabanero_config.yaml
docker push $IMAGE_REGISTRY/$IMAGE_ORG/$NGINX_IMAGE_NAME

# mirror necessary images
oc image mirror \
   docker.io/kabanero/java-openliberty:0.2.3 $IMAGE_REGISTRY/$IMAGE_ORG/java-openliberty:0.2.3 $IMAGE_REGISTRY/$IMAGE_ORG/java-openliberty:0.2

