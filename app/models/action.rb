class Action < ActiveRecord::Base
  belongs_to :alert

  def perform_action(track_id)
    if action_type == "download"
      puts "Downloading #{track_id} for user #{alert.soundcloud_user.username}"
    elsif action_type == "like"
      alert.soundcloud_user.like_track(track_id)
      puts "Liking #{track_id} for user #{alert.soundcloud_user.username}"
    elsif action_type == "email"
      MatchMailer.perform_async(track_id, alert.id)
      puts "Emailing #{alert.soundcloud_user.username} about track ##{track_id}"
    end
  end

end
