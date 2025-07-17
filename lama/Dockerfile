# --- Stage 1: Builder ---
FROM php:8.1-cli-alpine AS builder

ARG MANTIS_VERSION=2.26.2

# Install alat bantu dan ekstensi PHP untuk Composer
RUN apk add --no-cache \
    git curl unzip tar libzip-dev zlib-dev oniguruma-dev autoconf g++ make \ 
    libjpeg-turbo-dev libpng-dev freetype-dev

RUN docker-php-ext-install zip mbstring pdo pdo_mysql mysqli opcache gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

WORKDIR /build

# Download source MantisBT versi stabil
RUN curl -L https://github.com/mantisbt/mantisbt/archive/refs/tags/release-${MANTIS_VERSION}.tar.gz \
    | tar xz --strip-components=1

# Jalankan Composer install
RUN composer install --no-dev --optimize-autoloader
# CMD ["sh"]

# Tambahkan plugin TimeTracking (opsional)
RUN git clone https://github.com/mantisbt-plugins/TimeTracking.git plugins/TimeTracking


# --- Stage 2: Runtime ---
FROM php:8.1-fpm-alpine

# Install runtime: nginx + ekstensi PHP
RUN apk add --no-cache nginx libjpeg-turbo-dev libpng-dev libzip-dev oniguruma-dev \
  && docker-php-ext-install pdo pdo_mysql mysqli gd zip opcache mbstring

# Set direktori kerja
WORKDIR /var/www/html

# Copy hasil build dari tahap builder
COPY --from=builder /build /var/www/html

# Copy konfigurasi nginx dan file tambahan (jika ada)
COPY nginx.conf /etc/nginx/nginx.conf
COPY config_inc_addon.php /var/www/html/config/config_inc_addon.php

# Atur hak akses
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
VOLUME /var/www/html

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
