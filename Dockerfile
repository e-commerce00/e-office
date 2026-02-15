# Gunakan image PHP CLI resmi
FROM php:8.2-cli

# Install GD dan dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install Composer (jika belum ada di image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Salin file composer
COPY composer.json composer.lock ./

# Install dependencies via Composer
RUN composer install --optimize-autoloader --no-scripts --no-interaction

# Salin sisa kode aplikasi
COPY . .

# Default command (opsional)
CMD ["php", "index.php"]