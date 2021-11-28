# Locust ECS Compose

## Overview
This repository houses a docker-compose file for use with Amazon ECS.  The intention is to make a highly scalable Locust.io load generator using Amazon ECS Fargate by modifying the Locust example docker-compose file available in the Locust.io repository at:

https://github.com/locustio/locust/blob/master/examples/docker-compose/docker-compose.yml

## Prerequisites
- Amazon ECS CLI
- Docker installed locally

## To deploy
1. Set the local docker context to point to ECS
    ```
    docker context create ecs myecscluster
    docker context use myecscluster
    ```
1. Build the S3 enabled Locust container
    ```
    docker build . -t local/s3locust
    ```
1. Create an ECR repository and log in to ECR
    ```
    REGION=${AWS_DEFAULT_REGION}
    ACCT_NO=$(aws sts get-caller-identity --query 'Account' --output text)
    aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCT_NO}.dkr.ecr.${REGION}.amazonaws.com
    REPO_URI=$(aws ecr create-repository --repository-name s3locust --region ${REGION} --query 'repository.repositoryUri' --output text)
    ```
1. Push the S3-enabled Locust container to ECR
    ```
    docker tag jpbarto/locust ${REPO_URI}:latest
    docker push ${REPO_URI}:latest
    ```
1. Update the `docker-compose.yaml` file to reference the ECR repository
1. Start the composition
    ```
    docker compose up
    ```
