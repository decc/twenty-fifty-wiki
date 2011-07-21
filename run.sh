#!/usr/bin/env bash
echo "Deprecated"
echo "Use the foreman gem"
echo "foreman start --env config/development.env"
echo "or"
echo "foreman start --env config/production.env"
echo "Should also have a crontab that triggers emails:  bundle exec rails runner 'ChangeNotifications.send_all_change_notifications'"