FROM php:7.3-apache

# Install the PHP extensions we need
# all apt-get update and install in one command else docker cache may ignore apt-update 
# and assume from cache when changes to image
RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                libicu-dev \
        ; \
        docker-php-ext-install \
                intl \
                mbstring \
                mysqli \
                opcache \
        ; \
        pecl install apcu-5.1.18; \
        docker-php-ext-enable \
                apcu 

# Version
ENV MEDIAWIKI_MAJOR_VERSION=1.34
ENV MEDIAWIKI_BRANCH=REL1_34
ENV MEDIAWIKI_VERSION=1.34.0
ENV MEDIAWIKI_SHA512=b6b1aeec26a1c114eeec0bdf18d4b3160fe02dac2920a39a045acb74e62aa8f8a28e6a81c01fedba7976e4dd0c96463e0f1badfddd3015eef9197b01586a236d

# MediaWiki setup
RUN set -eux; \
        curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
        echo "${MEDIAWIKI_SHA512} *mediawiki.tar.gz" | sha512sum -c -; \
        tar -x --strip-components=1 -f mediawiki.tar.gz; \
        rm mediawiki.tar.gz; \
        chown -R www-data:www-data extensions skins cache images
