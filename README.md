# Laravel CI/CD Action

This GitHub Action automates the CI/CD process for Laravel applications.

## Inputs

- `production-branch`: The production branch to deploy. Default is `production`.
- `vps-host`: VPS host.
- `vps-username`: VPS username.
- `vps-private-key`: VPS private key.
- `deploy-path`: Deployment path on the VPS. Default is `/var/www/html/project_name/`.
- `php-version`: PHP version to use. Default is `8.0`.
- `github_token`: To access and create issue.

## Outputs

- `deployment-status`: The status of the deployment.

## Example Usage

```yaml
name: Laravel CI/CD Workflow

on:
  push:
    branches:
      - production

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - name: Run CI job
        uses: basantsd/laravel-ci-cd@clean
        with:
          job: 'ci'
          github_token: ${{ secrets.GITHUB_TOKEN }}
          repo: 'your-username/your-repo'

  code_cleanup:
    runs-on: ubuntu-latest
    needs: ci
    steps:
      - name: Run Code Cleanup job
        uses: basantsd/laravel-ci-cd@clean
        with:
          job: 'code_cleanup'
          github_token: ${{ secrets.GITHUB_TOKEN }}
          repo: 'your-username/your-repo'

  cd:
    runs-on: ubuntu-latest
    needs: code_cleanup
    steps:
      - name: Run CD job
        uses: basantsd/laravel-ci-cd@clean
        with:
          job: 'cd'
          vps_private_key: ${{ secrets.VPS_PRIVATE_KEY }}
          vps_username: ${{ secrets.VPS_USERNAME }}
          vps_host: ${{ secrets.VPS_HOST }}
          deploy_path: '/path/to/deploy'
          production_branch: 'main'
          php_version: '8.2'
          github_token: ${{ secrets.GITHUB_TOKEN }}
          repo: 'your-username/your-repo'
