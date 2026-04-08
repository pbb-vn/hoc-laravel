FROM php:8.2-apache

# Cài đặt công cụ hỗ trợ cài extension cực nhanh
ADD https://github.com /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cấu hình Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Copy code
WORKDIR /var/www/html
COPY . .

# Cài đặt dependencies (Bỏ qua scripts để tránh lỗi migrate khi chưa có DB)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Cấp quyền
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80
