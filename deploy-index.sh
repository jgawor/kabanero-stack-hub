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

YAML_FILE=openshift/openshift.yaml
cp $YAML_FILE.tpl $YAML_FILE 
sed -i -e '/host:/d' $YAML_FILE
sed -i -e "s|REGISTRY|$IMAGE_REGISTRY|" $YAML_FILE
sed -i -e "s|NAMESPACE|$IMAGE_ORG|" $YAML_FILE
sed -i -e 's|TAG|latest|' $YAML_FILE
sed -i -e "s|DATE|$(date --utc '+%FT%TZ')|" $YAML_FILE
oc -n kabanero apply --validate=false -f $YAML_FILE
