desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  ChangeNotifications.send_all_change_notifications
end