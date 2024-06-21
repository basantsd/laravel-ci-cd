# Laravel CI/CD Action

This GitHub Action automates the CI/CD process for Laravel applications.

## Inputs

- `production-branch`: The production branch to deploy. Default is `production`.
- `vps-host`: VPS host.
- `vps-username`: VPS username.
- `vps-private-key`: VPS private key.
- `deploy-path`: Deployment path on the VPS. Default is `/var/www/html/project_name/`.
- `php-version`: PHP version to use. Default is `8.0`.

## Outputs

- `deployment-status`: The status of the deployment.

## Example Usage

```yaml
name: Laravel CI/CD

on:
  push:
    branches:
      - production

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Laravel CI/CD
      uses: your-username/laravel-ci-cd-action@v1
      with:
        production-branch: 'production'
        vps-host: ${{ secrets.VPS_HOST }}
        vps-username: ${{ secrets.VPS_USERNAME }}
        vps-private-key: ${{ secrets.VPS_PRIVATE_KEY }}
        deploy-path: '/var/www/html/project_name/'
        php-version: '8.0'
