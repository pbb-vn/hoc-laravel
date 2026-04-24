#!/bin/sh

# Chạy migration
echo "Running migrations..."
php artisan migrate --force

# Sau đó khởi động Apache (lệnh mặc định của image php:apache)
echo "Starting Apache..."
exec apache2-foreground
