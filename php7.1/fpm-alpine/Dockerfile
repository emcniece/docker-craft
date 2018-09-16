FROM php:7.1-fpm-alpine

MAINTAINER Eric McNiece "emcniece@gmail.com"

RUN apk add --no-cache \
    bash \
    sed \
    openssl \
    tar

# install the PHP extensions we need
RUN set -ex; \
  \
  apk add --no-cache --virtual .build-deps \
    libjpeg-turbo-dev \
    libpng-dev \
  ; \
  \
  docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
  docker-php-ext-install gd mysqli opcache zip pdo pdo_mysql; \
  \
  runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )"; \
  apk add --virtual .craft-phpexts-rundeps $runDeps; \
  apk del .build-deps

RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

VOLUME /var/www/html

ENV PAGER more
ENV PHPREDIS_VERSION 3.1.2


RUN docker-php-source extract \
  && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
  && tar xfz /tmp/redis.tar.gz \
  && rm -r /tmp/redis.tar.gz \
  && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
  && docker-php-ext-install redis \
  && docker-php-source delete



ADD ./add/uploads.ini ./add/craft.ini ./add/errors.ini /usr/local/etc/php/conf.d/




# Set craft cms version
ENV CRAFT_VERSION=latest CRAFT_BUILD=0

ENV CRAFT_ZIP=latest-v2.zip

# Remove default webroot files & set PHP session handler to Redis
RUN rm -rf /var/www/html/* \
 && touch /var/log/fpm-php.www.log

# Download the latest Craft (https://craftcms.com/support/download-previous-versions)
ADD https://craftcms.com/$CRAFT_ZIP /tmp/$CRAFT_ZIP

# Extract craft to webroot & remove default template files
RUN unzip -qqo /tmp/$CRAFT_ZIP 'craft/*' -d /var/www/ \
 && mkdir -p /var/www/public \
 && unzip -qqoj /tmp/$CRAFT_ZIP 'public/*' -d /var/www/public \
 && rm /tmp/$CRAFT_ZIP

# Add default config
ADD ./v2/config /var/www/craft/config
ADD ./add/.bashrc /root
COPY ./php7.1/fpm-alpine/docker-entrypoint.sh /usr/local/bin/

# Cleanup
RUN chown -Rf www-data:www-data /var/www/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
