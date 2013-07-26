desc "This task is called by the Heroku scheduler add-on"
task :update_alert => :environment do
  puts "Updating alert..."
  Alert.send_all_alerts
  puts "done."
end