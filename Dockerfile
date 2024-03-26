#stage1
FROM php:8.2-fpm-alpine AS builder

WORKDIR /var/www/html

RUN apk update && \
    apk add --no-cache \
        libzip-dev \
        unzip \
        libonig-dev \
        libxml2-dev \
        git && \
    docker-php-ext-install pdo_mysql zip mbstring exif pcntl bcmath opcache && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug

COPY . .

COPY .env .env

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
RUN apk add --no-cache sqlite3

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --optimize-autoloader

RUN php artisan key:generate

RUN composer update

#stage2
FROM php:8.2-fpm-alpine

WORKDIR /var/www/html

COPY --from=builder /var/www/html /var/www/html

RUN sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

EXPOSE 8000

CMD ["apache2-foreground"]

RUN php artisan migrate:fresh --seed
