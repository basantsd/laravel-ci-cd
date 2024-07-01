#!/bin/bash
set -e

job=$1

if [ "$job" == "ci" ]; then
  # CI steps
  echo "Running CI steps..."
  composer install --prefer-dist --no-progress --no-suggest --no-interaction
  php artisan test

elif [ "$job" == "cd" ]; then
  # CD steps
  echo "Running CD steps..."
  composer install --prefer-dist --no-progress --no-suggest --no-interaction
  ssh -o StrictHostKeyChecking=no -i $VPS_PRIVATE_KEY $VPS_USERNAME@$VPS_HOST << EOF
  cd $DEPLOY_PATH
  sudo chown -R $USER:www-data storage/ bootstrap/cache public/
  sudo chmod -R 775 storage bootstrap/cache public/
  git reset --hard
  git clean -fd
  git pull origin $PRODUCTION_BRANCH
  /usr/bin/php$PHP_VERSION $(which composer) install --no-dev --prefer-dist --optimize-autoloader
  /usr/bin/php$PHP_VERSION artisan optimize
  /usr/bin/php$PHP_VERSION artisan optimize:clear
  /usr/bin/php$PHP_VERSION artisan storage:link
  EOF

elif [ "$job" == "code_cleanup" ]; then
  # Code Cleanup steps
  echo "Running code cleanup steps..."
  composer install --prefer-dist --no-progress --no-suggest --no-interaction
  composer require --dev laravel/pint
  composer require --dev squizlabs/php_codesniffer
  npm install
  ./vendor/bin/pint || vendor/bin/pint
  ./vendor/bin/phpcs --standard=PSR12 app/ routes/ tests/ resources/ || vendor/bin/phpcs --standard=PSR12 app/ routes/ tests/ resources/
  npx eslint resources/**/*.js
  git config --local user.name "github-actions[bot]"
  git config --local user.email "github-actions[bot]@users.noreply.github.com"
  git add -A
  git commit -m "Apply code style fixes" || echo "No changes to commit"
else
  echo "Invalid job"
  exit 1
fi
