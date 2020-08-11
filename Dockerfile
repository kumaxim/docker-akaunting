FROM php:7.4-fpm
LABEL maintainer="kumaxim@users.noreply.github.com"

ENV AKAUNTING_VERSION=2.0.19 \
    AKAUNTING_USER=www-data \
    AKAUNTING_INSTALL_DIR=/var/www/akaunting \
    AKAUNTING_DATA_DIR=/var/lib/akaunting \
    AKAUNTING_CACHE_DIR=/etc/docker-akaunting

ENV AKAUNTING_BUILD_DIR=${AKAUNTING_CACHE_DIR}/build \
    AKAUNTING_RUNTIME_DIR=${AKAUNTING_CACHE_DIR}/runtime

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      sudo \
      wget \
      unzip  \
      default-mysql-client \
      gettext-base \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libzip-dev \
      imagemagick \
      libmcrypt-dev \
      libpng-dev \
      libpq-dev \
      libxrender1 \
      locales \
      openssh-client \
      patch \
      zlib1g-dev \
      zip \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
    gd \
    bcmath \
    pcntl \
    pdo \
    pdo_pgsql \
    pdo_mysql \
    zip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

COPY runtime/ ${AKAUNTING_RUNTIME_DIR}/

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

WORKDIR ${AKAUNTING_INSTALL_DIR}

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["app:akaunting"]