ARG UBUNTU_VERSION=jammy

FROM ubuntu:$UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -qqq --allow-releaseinfo-change update

RUN apt -qqq install software-properties-common

RUN add-apt-repository --yes ppa:ondrej/php

RUN apt -qqq install ca-certificates && /usr/sbin/update-ca-certificates

ARG PHP_VERSION=8.2

RUN apt -qqq install php${PHP_VERSION}

RUN <<END bash

set -euo pipefail

PKGS=""

for MOD in bcmath bz2 cli curl dev gmp intl mbstring memcache mysql sqlite3 xml yaml ; do
    PKGS="$(printf "%s php%.1f-%s" "\${PKGS}" "${PHP_VERSION}" "\${MOD}")"
done

apt -qqq install \${PKGS}
END

RUN apt -qqq install php-pear composer libcurl4-openssl-dev

RUN pecl channel-update pecl.php.net

RUN (yes yes | head -5 ; echo no) | pecl install openswoole

RUN echo extension=openswoole.so > /etc/php/${PHP_VERSION}/cli/conf.d/99-openswoole.ini
