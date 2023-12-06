FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qqq

RUN apt-get install -qqq software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get upgrade -qqq

RUN apt-get install -qqq ca-certificates && /usr/sbin/update-ca-certificates

ARG PHP_VERSION=8.2

RUN apt-get install -qqq php${PHP_VERSION}

RUN <<END bash

set -euo pipefail

PKGS=""

for MOD in bcmath bz2 cli curl dev gmp intl mbstring memcache mysql sqlite3 xml yaml ; do
    PKG="$(printf "php%.1f-%s" "${PHP_VERSION}" "\${MOD}")"
    PKGS="\${PKGS} \${PKG}"
done

apt-get install -qqq \${PKGS}
END

RUN apt-get install -qqq php-pear composer libcurl4-openssl-dev

RUN pecl channel-update pecl.php.net

RUN (yes yes | head -5 ; echo no) | pecl install openswoole

RUN echo extension=openswoole.so > /etc/php/${PHP_VERSION}/cli/conf.d/99-openswoole.ini
