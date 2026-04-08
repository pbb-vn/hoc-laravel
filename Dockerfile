FROM php:8.2-apache

# Cập nhật apt-get và thêm libpq-dev (thư viện cần thiết cho PostgreSQL)
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev libonig-dev libxml2-dev \
    libpq-dev \
    unzip git curl \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các extension, nhớ thêm pdo_pgsql và pgsql
RUN docker-php-ext-install pdo_mysql pdo_pgsql pgsql mbstring exif pcntl bcmath zip intl gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . .

# Cài đặt dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs

# Cấp quyền cho storage và cache
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80

# Copy file entrypoint vào container
COPY entrypoint.sh /usr/local/bin/
# Cấp quyền thực thi
RUN chmod +x /usr/local/bin/entrypoint.sh

# Thiết lập file này chạy khi container khởi động
ENTRYPOINT ["entrypoint.sh"]
