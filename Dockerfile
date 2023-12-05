FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qqq

RUN apt-get install -qqq software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get upgrade -qqq

RUN apt-get install -qqq ca-certificates && /usr/sbin/update-ca-certificates

ARG PHP_VERSION=8.2

RUN apt-get install -qqq \
    php${PHP_VERSION} php${PHP_VERSION}-opcache php-cli php-bcmath php-bz2 php-curl \
    php-dev php-intl php-mbstring php-memcache php-mysql \
    php-xml php-yaml php-pear php-gmp php-sqlite3 \
    composer libcurl4-openssl-dev

RUN (yes yes | head -5 ; echo no) | pecl install openswoole

RUN echo extension=openswoole.so > /etc/php/${PHP_VERSION}/cli/conf.d/99-openswoole.ini
