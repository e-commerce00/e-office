FROM php:8.3-cli

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip unzip git curl pkg-config libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Create SQLite database & set permissions
RUN mkdir -p /app/database \
    && touch /app/database/database.sqlite \
    && chmod -R 775 storage bootstrap/cache /app/database

# Clear Laravel cache (JANGAN config:cache di build stage)
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Expose port (optional, tapi bagus untuk dokumentasi)
EXPOSE 8000

# Start Laravel server
CMD php -S 0.0.0.0:${PORT} -t public