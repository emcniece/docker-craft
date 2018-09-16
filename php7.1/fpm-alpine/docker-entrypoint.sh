#!/bin/bash

echo "HTML Directory:"
ls -al /var/www/html/

if [ -z "$(ls -A /var/www/html)" ]; then
  cp -r /var/www/public/* /var/www/html/
fi

echo "Starting Craft"
exec "$@"