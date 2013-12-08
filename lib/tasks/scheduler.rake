desc "This task is called by the Heroku scheduler add-on"

task :update_users => :environment do
  SoundcloudUser.update_oldest_users_async(10)
end

task :update_old_tracks => :environment do
  SoundcloudTrack.update_old_tracks(100)
end

