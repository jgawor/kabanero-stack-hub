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

BASE_DIR="$(cd $(dirname $0) && pwd)"
cd $BASE_DIR

YAML_FILE=openshift/openshift.yaml
cp $YAML_FILE.tpl $YAML_FILE 
sed -i -e '/host:/d' $YAML_FILE
sed -i -e "s|REGISTRY|$IMAGE_REGISTRY|" $YAML_FILE
sed -i -e "s|NAMESPACE|$IMAGE_ORG|" $YAML_FILE
sed -i -e 's|TAG|latest|' $YAML_FILE
sed -i -e "s|DATE|$(date --utc '+%FT%TZ')|" $YAML_FILE
oc -n kabanero apply --validate=false -f $YAML_FILE

ROUTE=$(oc get route kabanero-index --no-headers -o=jsonpath='{.status.ingress[0].host}' -n kabanero)
STACK_HUB_URL="http://$ROUTE/kabanero-stack-hub-index.yaml"

echo
echo "Stack Hub Index: $STACK_HUB_URL"
echo
echo "You can run the following command to configure appsody:"
echo "  appsody repo add cp4apps $STACK_HUB_URL"
echo "  appsody list cp4apps"

echo
echo "Patching Kabanero resource"
oc patch kabanero kabanero -n kabanero -p "[{'op': 'replace', 'path': '/spec/stacks/repositories/0/https/url', 'value':'$STACK_HUB_URL'}]" --type=json
