FROM php:7.1-fpm-alpine
RUN apk add --no-cache \
        libpng-dev \ 
    && docker-php-ext-install pdo_mysql gd 
