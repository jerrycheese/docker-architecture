FROM php:7.1-fpm-alpine
RUN apk add --no-cache \
        libpng-dev libpng \ 
    && apk --update add freetype-dev \
    && docker-php-ext-configure gd --with-freetype-dir --enable-gd-native-ttf \
    && docker-php-ext-install pdo_mysql gd zip \
    && apk del libpng-dev \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && export PATH="$PATH:$HOME/.composer/vendor/bin"
