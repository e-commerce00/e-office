# Gunakan PHP 8.3 CLI resmi
FROM php:8.3-cli

# Install dependency yang dibutuhkan untuk GD, ZIP, dan tools build
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip unzip \
    pkg-config \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Salin file composer
COPY composer.json composer.lock ./

# Install dependencies via Composer
RUN composer install --optimize-autoloader --no-scripts --no-interaction

# Salin sisa kode aplikasi
COPY . .

# Entry point (ubah sesuai entry point aplikasi)
CMD ["php", "index.php"]

# Jalankan Laravel web server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]