FROM php:8.2-apache 
# (Sửa thành 8.3-apache nếu composer.json yêu cầu 8.3)

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev libonig-dev libxml2-dev \
    unzip git curl \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath zip intl gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . .

# THAY ĐỔI QUAN TRỌNG: Thêm flag --ignore-platform-reqs
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs

RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80
