# Docker Dev
Dockerfiles for dev. Images are created using these files and pushed on ECR. Those images are used in dev docker-compose. You may use the sample docker-compose in this repo as a reference.

# Contributing
## PHP-Nginx Server
You can add any php extensions you want using the links provided in the dockerfile. You may also add any packages to alpine linux using apk add.

## Laravel Queue and Scheduler
This image can be used to run a Laravel queue and Laravel scheduler. It uses the php-fpm-alpine image.  You can add any extensions as required and supported.

---
Please note that the image created using these Dockerfiles will be used by all applications for dev purposes. So please do not remove any packages.