#! /bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "This script is to build the app on the docker EC2 instance and push the image to ECR"
  echo "Default tag name is latest-dev"
  exit 0
fi

aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev

docker build -t php:latest-dev -f php/Dockerfile ./php
docker tag php:latest-dev 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev:php
docker push 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev:php

docker build -t queue-scheduler:latest-dev -f queue-scheduler/Dockerfile ./queue-scheduler
docker tag queue-scheduler:latest-dev 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev:queue-scheduler
docker push 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev:queue-scheduler