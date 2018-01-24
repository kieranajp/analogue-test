FROM php:7.2-fpm-alpine

ENV COMPOSER_VERSION=1.6.2 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PHP_EXT_XDEBUG_VERSION=2.6.0beta1

# Install PHP dependencies
# See https://github.com/docker-library/php
RUN set -ex \
    && apk add --no-cache libpq libmagic \
    && apk add --no-cache --virtual .build-dependencies ${PHPIZE_DEPS} postgresql-dev \
    && docker-php-ext-install opcache pdo pdo_pgsql bcmath \
    && pecl install xdebug-${PHP_EXT_XDEBUG_VERSION} phpredis \
    && docker-php-ext-enable xdebug \
    && apk del .build-dependencies

# Install Composer
# See https://github.com/composer/docker/blob/master/1.4/Dockerfile
RUN set -ex \
    && curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
    && php -r " \
    \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm /tmp/installer.php \
    && composer --ansi --version --no-interaction

# Install application/service
ENV APP_DIR /server/http
WORKDIR ${APP_DIR}
COPY . ${APP_DIR}

## Copy PHP ini based of off https://github.com/php/php-src/blob/PHP-7.1.1/php.ini-production
COPY ./docker/php-fpm/php.ini ${PHP_INI_DIR}/

RUN set -ex \
    # Install project dependencies
    && composer install --prefer-dist --ignore-platform-reqs --no-interaction \
    ## Customize PHP fpm configuration
    && sed -i -e "s/;clear_env\s*=\s*no/clear_env = no/g" /usr/local/etc/php-fpm.conf \
    && sed -i -e "s/;request_terminate_timeout\s*=[^\n]*/request_terminate_timeout = 300/g" /usr/local/etc/php-fpm.conf \
    && php-fpm --test

