class MatchMailer
  include Sidekiq::Worker
  sidekiq_options :queue => :match_mailer, :retry => true

  def perform(track_id, alert_id)
    track = SoundcloudTrack.find_by_track_id(track_id)
    alert = Alert.find(alert_id)

    AlertMailer.match(track, alert).deliver
  end
end
