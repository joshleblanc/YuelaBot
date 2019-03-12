#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
set -e

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

exec bundle exec "$@"