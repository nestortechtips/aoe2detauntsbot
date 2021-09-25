#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

#Checks if the Jenkins Build number is present 
if [ $# -eq 0 ]
  then
    echo "No arguments supplied."
    echo "Usage: build.sh JENKINS_BUILD_NUMBER"
fi

JENKINS_BUILD_NUMBER=$1

echo -e "${YLW}Building Container Image in Cloud build ${NC}"
echo -e "${YLW} Assigning new Tag for Container Image in Kubernetes Deployment${NC}"
sed -i -e "s/TAG/$JENKINS_BUILD_NUMBER/g" $GCP_BUILD_PATH/aoe2detauntsbot/manifests/10-aoe2tauntbot-deployment.yaml
echo -e "${YLW} Assigning new Tag for Container Image${NC}"
sed -i -e "s/TAG/$JENKINS_BUILD_NUMBER/g" $GCP_BUILD_PATH/aoe2detauntsbot/cb.yaml
echo -e "${YLW} Submitting Build to Cloud Build${NC}"
gcloud builds submit --config $GCP_BUILD_PATH/aoe2detauntsbot/cb.yaml
echo -e "${YLW} Applying Kubernetes Manifest${NC}"
kubectl apply -f $GCP_BUILD_PATH/aoe2detauntsbot/manifests/
echo -e "${YLW} annotating Manifest${NC}"
cd $GCP_BUILD_PATH/aoe2detauntsbot; kubectl annotate deploy/aoe2detauntsbot -n aoe2bot kubernetes.io/change-cause="$(git log -1 --pretty=format:"%s")" --record=false --overwrite=true
echo -e "${YLW} Deleting Local Files${NC}"
rm -rf $GCP_BUILD_PATH/aoe2detauntsbot/