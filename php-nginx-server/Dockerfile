# Refer: https://wiki.alpinelinux.org/wiki/Nginx_with_PHP
# Refer: https://github.com/wemakewaves/php-docker-bench/tree/master/custom-fpm

FROM alpine:3.11

# Add wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it.sh

# Add S6 supervisor (for graceful stop)
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz /tmp/s6-overlay-amd64.tar.gz
RUN apk upgrade --update --no-cache \
  && apk add bash --no-cache \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && chmod +x /bin/wait-for-it.sh \
  && rm /tmp/s6-overlay-amd64.tar.gz \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /run/nginx
ENTRYPOINT ["/init"]

ENV PHP_MAJOR_VERSION="7"
ENV PHP_VERSION="7.4"
ENV PHP_FPM_USER="www"
ENV PHP_FPM_GROUP="www"
ENV PHP_FPM_LISTEN_MODE="0660"
ENV PHP_MEMORY_LIMIT="512M"
ENV PHP_MAX_UPLOAD="50M"
ENV PHP_MAX_FILE_UPLOAD="200"
ENV PHP_MAX_POST="100M"
ENV PHP_DISPLAY_ERRORS="On"
ENV PHP_DISPLAY_STARTUP_ERRORS="On"
ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO=0
ENV PHP_MAX_EXECUTION_TIME=300
ENV TIMEZONE="Asia/Tokyo"

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN \
  # Install Nginx
  apk add nginx --no-cache \
  && adduser -D -u 1000 -g 'www' www \
  && mkdir /var/www/html \
  && chown -R www:www /var/lib/nginx \
  && chown -R www:www /var/www/html \
  && rm -rf /etc/nginx/nginx.conf \
  # Install PHP FPM and Extensions
  && echo "https://dl.bintray.com/php-alpine/v3.11/php-${PHP_VERSION}" >> /etc/apk/repositories \
  && apk upgrade --update --no-cache \
  && apk add --no-cache curl tzdata redis \
  # Available PHP Packages: https://github.com/codecasts/php-alpine
  php php-bcmath php-curl php-common php-dom php-fpm php-gd php-gmp php-iconv php-json php-mbstring \
  php-opcache php-pdo php-pdo_mysql php-redis php-session php-sockets php-xml php-zip php-zlib \
  # Update www.conf
  && sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf \
  && sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf \
  && sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf \
  && sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf \
  && sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf \
  && sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php${PHP_MAJOR_VERSION}/php-fpm.d/www.conf \
  # Update php.ini
  && sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  && sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  # && sed -i "s|max_execution_time =.*|max_execution_time = ${PHP_MAX_EXECUTION_TIME}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini \
  # Update timezone
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone \
  && sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php${PHP_MAJOR_VERSION}/php.ini

# Copy NGINX service script
COPY start-nginx.sh /etc/services.d/nginx/run

# Copy PHP-FPM service script
COPY start-fpm.sh /etc/services.d/php_fpm/run

RUN chmod 755 /etc/services.d/nginx/run \
    && chmod 755 /etc/services.d/php_fpm/run \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/sterr /var/log/nginx/error.log