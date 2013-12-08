class SoundcloudTrack < ActiveRecord::Base

  belongs_to :soundcloud_user, primary_key: "user_id", foreign_key: "user_id"

  validates :title, presence: true
  validates :user_id, presence: true
  validates :track_id, presence: true
  
  SOUNDCLOUD_CLIENT_ID     = "de461ac8fecca76fb5b8a1e9bd966f3a"

  def get_widget_url
    url = "http://w.soundcloud.com/player/?url="\
          "https://api.soundcloud.com/tracks/#{track_id}"\
          "&auto_play=false"\
          "&auto_advance=true"\
          "&buying=false"\
          "&liking=true"\
          "&download=true"\
          "&sharing=true"\
          "&show_artwork=false"\
          "&show_comments=true"\
          "&show_playcount=true"\
          "&show_user=true"\
          "&start_track=0"\
          "&callback=true"
  end

  def get_track_url
    url = "https://api.soundcloud.com/tracks/#{track_id}/"\
          "stream?client_id=" + SOUNDCLOUD_CLIENT_ID
  end

  def get_download_url
    url = "https://api.soundcloud.com/tracks/#{track_id}/"\
          "stream?client_id=" + SOUNDCLOUD_CLIENT_ID
  end

  def update_old_tracks(count)
    order.('updated_last DESC').limit(count)
  end

end
