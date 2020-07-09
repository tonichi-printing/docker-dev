FROM php:7.4-fpm-alpine

RUN apk add --update --no-cache autoconf g++ make libpng-dev oniguruma-dev libxml2-dev openssl-dev \
  libjpeg-turbo-dev freetype-dev libzip-dev zlib-dev \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-install pdo_mysql pcntl sockets gd bcmath \
  && pecl install redis \
  && docker-php-ext-enable redis