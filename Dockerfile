# --- STAGE 1: PHP Base ---
FROM php:8.3-fpm-alpine AS base

# Passing an environment variable to a Dockerfile
ARG APP_ENV=local
ENV APP_ENV=${APP_ENV}

# Install system utilities and dependencies for PHP extensions
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    libzip-dev \
    postgresql-dev \
    libpq \
    python3 \
    make \
    g++ \
    oniguruma-dev \
    libxml2-dev \
    supervisor \
    linux-headers \
    nodejs \
    yarn

# Install the PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    pcntl \
    exif \
    sockets \
    pdo_pgsql \
    zip \
    mbstring \
    bcmath \
    dom \
    xml

# Install Redis extension
RUN if ! php -m | grep -q 'redis'; then pecl install redis && docker-php-ext-enable redis; fi

# Install GD extension
RUN apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install Imagick extension
RUN apk add --no-cache imagemagick imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install RoadRunner for Octane
COPY --from=spiralscout/roadrunner:2025.1 /usr/bin/rr /usr/bin/rr

# Install Kafka extension
RUN apk add --no-cache librdkafka librdkafka-dev \
    && pecl install rdkafka \
    && docker-php-ext-enable rdkafka

WORKDIR /app

# --- STAGE 2: Node.js Asset Builder ---
FROM node:22-alpine AS node_builder

WORKDIR /app

# --- STAGE 3: Development Image ---
FROM base AS local

# Install Xdebug for debugging in development
RUN if [ "$APP_ENV" = "local" ] && ! php -m | grep -q 'xdebug'; then pecl install xdebug && docker-php-ext-enable xdebug; fi

# Expose the port for local development
EXPOSE 8585

# Command for local development
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8585"]
#CMD ["php", "artisan", "octane:start", "--server=roadrunner", "--host=0.0.0.0", "--port=${PORT:-8585}"]
