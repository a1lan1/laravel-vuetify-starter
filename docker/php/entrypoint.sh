#!/bin/sh
set -e

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

if [ ! -f vendor/autoload.php ]; then
  echo "Installing composer dependencies..."
  composer install --no-interaction
fi

if [ ! -f ".env" ]; then
    if [ ! -f ".env.example" ]; then
      echo "ERROR: .env.example not found!"
      exit 1
    fi

  cp .env.example .env;
fi

if [ -z "$(grep '^APP_KEY=' .env | grep -v '=$')" ]; then php artisan key:generate; fi
if [ ! -L "public/storage" ]; then php artisan storage:link; fi

echo "Waiting for database..."
while ! nc -z pgsql 5432; do
  echo "Waiting for PostgreSQL..."
  sleep 1
done
echo "Database is ready!"
php artisan migrate:fresh --force

if [ ! -d "node_modules" ]; then yarn install; fi
if [ ! -d "public/build" ]; then yarn build; fi

echo "Waiting for laravel_app to be ready..."
until php artisan migrate:status > /dev/null 2>&1; do
  echo "Laravel not ready yet..."
  sleep 5
done
echo "Laravel is up!"

exec "$@"
