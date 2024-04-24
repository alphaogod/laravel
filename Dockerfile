# Stage 1: Builder
FROM php:8.2-cli-alpine AS builder

WORKDIR /var/www/html

# Install dependencies (including the C compiler)
RUN apk update && apk add --no-cache \
    libzip-dev unzip libxml2-dev sqlite-dev git oniguruma-dev autoconf build-base
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip mbstring exif pcntl bcmath opcache
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Copy application files
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader \
    && php artisan key:generate \
    && composer update

# Stage 2: Final image
FROM php:8.2-cli-alpine

WORKDIR /var/www/html

# Copy built files from builder stage
COPY --from=builder /var/www/html /var/www/html

# Expose port
EXPOSE 8082

# Add database persistence
VOLUME /var/lib/mysql

# Run migrations
CMD php artisan migrate:fresh --seed && php artisan serve --host=0.0.0.0 --port=8082
