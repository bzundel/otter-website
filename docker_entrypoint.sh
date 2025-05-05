#!/bin/sh

echo "Running migrations and seeding"
echo "Waiting for database to be up and running..."

while ! pg_isready -h db -U postgres; do
	sleep 1
done

/app/bin/otter_website eval "OtterWebsite.Release.migrate"
/app/bin/otter_website eval "OtterWebsite.Release.seed"

exec /app/bin/otter_website start
