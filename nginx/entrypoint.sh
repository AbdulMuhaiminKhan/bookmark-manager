#!/bin/sh
set -e

# Wait for web service to resolve and be available
echo "Waiting for web service..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if getent hosts web >/dev/null 2>&1; then
        echo "Web service resolved"
        break
    fi
    echo "Attempt $attempt/$max_attempts: Waiting for web service to resolve..."
    sleep 1
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Web service did not resolve in time"
    exit 1
fi

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"
