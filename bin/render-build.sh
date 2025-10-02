#!/usr/bin/env bash
# exit on error
set -o errexit

apt-get update && apt-get install -y libpq-dev
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate