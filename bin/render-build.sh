#!/usr/bin/env bash
# exit on error
set -euxo pipefail

bundle install --jobs=4 --retry=3
bundle exec rails --version
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate