#! /bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "This script is to build the app on the docker EC2 instance and push the image to ECR"
  echo "Default tag name is latest-dev"
  exit 0
fi

ssh -i /Users/mb21706/Work/dev/keys/tonichiaws.pem -t ec2-user@ec2-54-248-34-26.ap-northeast-1.compute.amazonaws.com << EOF
  aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev

  sudo service docker start

  cd docker-dev
  git pull

  docker build -t php-nginx-server:latest-dev -f php-nginx-server/Dockerfile ./php-nginx-server
  docker tag php-nginx-server:latest-dev 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev:php-nginx-server
  docker push 477120415291.dkr.ecr.ap-northeast-1.amazonaws.com/dev:php-nginx-server
EOF