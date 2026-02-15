FROM php:8.3-cli

# Set working directory
WORKDIR /app

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip \
    libsqlite3-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    pkg-config \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_sqlite zip gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Create SQLite database file inside container
RUN mkdir -p database \
    && touch database/database.sqlite \
    && chmod -R 775 storage bootstrap/cache database

# Railway dynamic port
ENV PORT=8080
EXPOSE 8080

# Start Laravel properly (runtime safe)
CMD sh -c "\
php artisan config:clear && \
php artisan route:clear && \
php artisan view:clear && \
php artisan migrate --force && \
php -S 0.0.0.0:${PORT:-8080} -t public"