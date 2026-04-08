FROM php:8.2-apache

# Cài đặt các thư viện hệ thống cần thiết trước
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các PHP extensions (Tách ra để tránh lỗi hàng loạt)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath zip intl

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cấu hình Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . .

# Cài đặt Laravel dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Cấp quyền cho Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80
