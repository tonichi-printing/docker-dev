#!/usr/bin/with-contenv sh
set -e;

# Start PHP-FPM
/usr/sbin/php-fpm${PHP_MAJOR_VERSION} -R --nodaemonize