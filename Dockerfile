# --- Stage 1: Build & Install Dependencies ---
FROM php:8.2-cli-alpine AS builder

ARG MANTIS_VERSION=2.26.2

# Install tools & PHP extensions for composer
RUN apk add --no-cache \
    git curl unzip tar \
    libzip-dev zlib-dev oniguruma-dev autoconf g++ make \
    libjpeg-turbo-dev libpng-dev freetype-dev

# Install required PHP extensions (incl. GD)
RUN docker-php-ext-install zip mbstring pdo pdo_mysql mysqli opcache gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

WORKDIR /build

# Download MantisBT
RUN curl -L https://github.com/mantisbt/mantisbt/archive/refs/tags/release-${MANTIS_VERSION}.tar.gz \
    | tar xz --strip-components=1

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Add plugin (optional)
RUN git clone https://github.com/mantisbt-plugins/TimeTracking.git plugins/TimeTracking


# --- Stage 2: Runtime ---
FROM php:8.2-fpm-alpine

# Install runtime packages
RUN apk add --no-cache nginx libjpeg-turbo-dev libpng-dev freetype-dev \
    libzip-dev oniguruma-dev

# Install runtime PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli gd zip opcache mbstring

WORKDIR /var/www/html

# Copy build result
COPY --from=builder /build /var/www/html

# Copy nginx config & entrypoint
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set ownership
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["/entrypoint.sh"]
