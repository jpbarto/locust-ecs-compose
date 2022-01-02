#!/bin/sh

set -e

REGION="${AWS_DEFAULT_REGION:-us-east-2}"
ACCT_NO=$(aws sts get-caller-identity --query 'Account' --output text)

# This script will 
# - build a docker container using the Dockerfile, 
# - create an ECS Fargate cluster on AWS,
# - push the container to an ECR repository,
# - create and run a task on the cluster to wipe the account
#
# This script assumes that Docker and Terraform are installed locally.

LOCAL_IMAGE_TAG='local/locust:latest'
docker buildx build --platform linux/amd64 . -t ${LOCAL_IMAGE_TAG}

export AWS_DEFAULT_REGION=${REGION}
ECR_URL=$(aws ecr create-repository --repository-name s3locust --region ${REGION} --query 'repository.repositoryUri' --output text)

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCT_NO}.dkr.ecr.${REGION}.amazonaws.com
docker tag ${LOCAL_IMAGE_TAG} "${ECR_URL}:latest"
docker push "${ECR_URL}:latest"

docker context use awscluster
docker compose up
docker compose ps --format json | jq '.[] | select(.Service=="master") | .Publishers[0].URL '
