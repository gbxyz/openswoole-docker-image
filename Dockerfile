FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qqq

RUN apt-get install -qqq software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get upgrade -qqq

RUN apt-get install -qqq \
    php8.2 php8.2-opcache php-cli php-bcmath php-bz2 php-curl \
    php-dev php-intl php-mbstring php-memcache php-mysql \
    php-xml php-yaml php-pear php-gmp php-sqlite3 \
    php-pcov composer ca-certificates libcurl4-openssl-dev

RUN (yes yes | head -5 ; echo no) | pecl install openswoole

RUN echo extension=openswoole.so > /etc/php/8.2/cli/conf.d/99-openswoole.ini

RUN /usr/sbin/update-ca-certificates
