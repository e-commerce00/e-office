FROM php:8.3-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip unzip git curl pkg-config libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . .

# ⬇️ INI WAJIB ADA
RUN composer install --no-dev --optimize-autoloader

RUN mkdir -p /app/database \
    && touch /app/database/database.sqlite \
    && chmod -R 775 storage bootstrap/cache /app/database

CMD php artisan serve --host=0.0.0.0 --port=$PORT