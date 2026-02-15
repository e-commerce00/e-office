FROM php:8.3-cli

# Set working directory
WORKDIR /app

# Install system dependencies + ekstensi PHP
RUN apt-get update && apt-get install -y \
    git curl zip unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    pkg-config \
    libonig-dev \
    libsqlite3-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql pdo_sqlite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy semua file project
COPY . .

# Install dependency Laravel
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set permission
RUN chmod -R 775 storage bootstrap/cache

# Cache config untuk production
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Railway kasih PORT dinamis, default 8080
ENV PORT=8080

EXPOSE 8080

# Gunakan PHP built-in server (lebih stabil daripada artisan serve)
CMD php -S 0.0.0.0:${PORT} -t public