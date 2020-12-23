FROM php:7.4-fpm-alpine

RUN apk add --update --no-cache autoconf g++ make libpng-dev oniguruma-dev libxml2-dev openssl-dev \
  libjpeg-turbo-dev freetype-dev libzip-dev zlib-dev gmp-dev \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-configure gmp \
  && docker-php-ext-install pdo pdo_mysql pcntl sockets gd bcmath zip gmp opcache \
  && pecl install redis \
  && docker-php-ext-enable redis \
  # fixes iconv library with alpine
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Install zsh and Oh my ZSH
RUN apk add zsh curl git \
  && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd