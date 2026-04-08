FROM php:8.2-fpm

# Cài đặt các phần phụ thuộc hệ thống
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip nginx

# Cài đặt các PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy mã nguồn vào container
WORKDIR /var/www
COPY . .

# Cài đặt dependencies của Laravel
RUN composer install --no-dev --optimize-autoloader

# Cấp quyền cho thư mục storage và cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Port mặc định
EXPOSE 80

# Lệnh khởi chạy (Bạn nên có một script start.sh hoặc cấu hình nginx)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
