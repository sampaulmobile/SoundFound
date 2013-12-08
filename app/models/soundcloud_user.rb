class SoundcloudUser < ActiveRecord::Base

  belongs_to :user, primary_key: "user_id"

  has_many :soundcloud_tracks, primary_key: "user_id", foreign_key: "user_id", dependent: :destroy

  has_many :soundcloud_recommendations, foreign_key: "user_id", class_name: "SoundcloudRecommendation", dependent: :destroy
  has_many :recommended_tracks, through: :soundcloud_recommendations, source: :soundcloud_track

  #has_many :soundcloud_matches, foreign_key: "user_id", class_name: "SoundcloudMatch", dependent: :destroy
  #has_many :matched_tracks, through: :soundcloud_matches, source: :soundcloud_track

  has_many :alerts

  SOUNDCLOUD_CLIENT_ID     = "de461ac8fecca76fb5b8a1e9bd966f3a"
  SOUNDCLOUD_CLIENT_SECRET = "6d35e91db8e21e1d381198b2caec9c3c"

  def self.soundcloud_client(options={})
    options = {
      :client_id     => SOUNDCLOUD_CLIENT_ID,
      :client_secret => SOUNDCLOUD_CLIENT_SECRET,
    }.merge(options)

    Soundcloud.new(options)
  end

  def soundcloud_client(options={})
    options= {
      :expires_at    => expires_at,
      :access_token  => access_token,
      :refresh_token => refresh_token
    }.merge(options)

    client = self.class.soundcloud_client(options)

    client.on_exchange_token do
      self.update_attributes!({
        :access_token  => client.access_token,
        :refresh_token => client.refresh_token,
        :expires_at    => client.expires_at,
      })
    end

    client
  end

  def like_track(t_id)
    soundcloud_client.put("/me/favorites/#{t_id}")
  end
  
  def unlike_track(t_id)
    soundcloud_client.delete("/me/favorites/#{t_id}")
  end

  def update_stream(count)
    page_size = 30;

    activities = soundcloud_client.get("/me/activities/", 
                                        order: 'created_at', 
                                        limit: page_size)

    finished = false
    num = 0
    (0..count).each do |i|

      activities.collection.each do |a|
        t = a.origin

        if SoundcloudRecommendation.exists?(track_id: t.id)
          finished = true
          break
        else
          soundcloud_recommendations.create(track_id:t.id)
          num += 1
        end

        #if SoundcloudTrack.exists?(track_id: t.id)
        #  process_track(t.id)
        #  next
        #elsif t.kind != "track"
        if t.kind != "track"
          next
        end

        tt = SoundcloudTrack.find_or_initialize_by_track_id(t.id)
        tt.user_id = t.user.id
        tt.title = t.title
        tt.duration = t.duration
        tt.comment_count = t.comment_count
        tt.favorite_count = t.favoritings_count
        tt.play_count = t.playback_count
        tt.download_count = t.download_count
        tt.downloadable = t.downloadable
        tt.uploaded_at = t.created_at
        tt.stats_last_updated = DateTime.now
        tt.save

        process_track(tt.id)
      end

      break if finished

      activities = self.soundcloud_client.get(activities.next_href,
                                              order: 'created_at', 
                                              limit: page_size)
    end

    self.tracks_updated_at = DateTime.now
    self.save

    puts "Added #{num} new tracks for #{self.username} (#{self.user_id})"
  end

  def process_track(t_id)
    if SoundcloudTrack.exists?(t_id)
      alerts.where(actionable: true).each do |a|
        a.process_track(t_id)
      end
    end
  end

  def self.update_oldest_users(count)
    puts "updating #{count} oldest users"

    start = Time.now
    users = order("tracks_updated_at DESC").limit(count)

    num = 0
    users.each do |u|
      if u.update_stream?
        num += 1
      end
    end

    runtime = Time.now - start
    puts "Updated #{num} users, took #{runtime} seconds."
  end

  def self.update_oldest_users_async(count)
    users = order("tracks_updated_at DESC").limit(count)

    users.each do |u|
      StreamUpdater.perform_async(u.id, 10)
    end
  end

  def filter_tracks(play_count_min, play_count_max, 
                    like_count_min, like_count_max, 
                    download_count_min, download_count_max,
                    duration_min, duration_max)

    where_exp = "1 = 1"
    if play_count_min != nil && play_count_min != ""
      where_exp += ' AND play_count >= ' + play_count_min.to_s
    end
    if play_count_max != nil && play_count_max != ""
      where_exp += ' AND play_count <= ' + play_count_max.to_s
    end

    if like_count_min != nil && like_count_min != ""
      where_exp += ' AND favorite_count >= ' + like_count_min.to_s
    end
    if like_count_max != nil && like_count_max != ""
      where_exp += ' AND favorite_count <= ' + like_count_max.to_s
    end

    if download_count_min != nil && download_count_min != ""
      where_exp += ' AND download_count >= ' + download_count_min.to_s
    end
    if download_count_max != nil && download_count_max != ""
      where_exp += ' AND download_count >= ' + download_count_max.to_s
    end

    if duration_min != nil && duration_min != ""
      where_exp += ' AND duration >= ' + (duration_min.to_f*1000*60).floor.to_s
    end
    if duration_max != nil && duration_max != ""
      where_exp += ' AND duration <= ' + (duration_max.to_f*1000*60).ceil.to_s
    end

    recommended_tracks.where(where_exp).order('uploaded_at DESC').limit(10)
  end

  def apply_alerts(alert_ids)

    if alert_ids == nil || alert_ids.length == 0
      return recommended_tracks.order('uploaded_at DESC').limit(10)
    end

    puts alert_ids

    i = 0
    where_exp = ""
    alert_ids.each do |id|

      puts "Filtering with alert ##{id}"

      alert = Alert.find(id)
      if i > 0
        where_exp += " AND "
      end 

      where_exp += "(1 = 1"
      if alert.play_count_min != nil && alert.play_count_min != ""
        where_exp += ' AND play_count >= ' + alert.play_count_min.to_s
      end
      if alert.play_count_max != nil && alert.play_count_max != ""
        where_exp += ' AND play_count <= ' + alert.play_count_max.to_s
      end

      if alert.like_count_min != nil && alert.like_count_min != ""
        where_exp += ' AND favorite_count >= ' + alert.like_count_min.to_s
      end
      if alert.like_count_max != nil && alert.like_count_max != ""
        where_exp += ' AND favorite_count <= ' + alert.like_count_max.to_s
      end

      if alert.download_count_min != nil && alert.download_count_min != ""
        where_exp += ' AND download_count >= ' + alert.download_count_min.to_s
      end
      if alert.download_count_max != nil && alert.download_count_max != ""
        where_exp += ' AND download_count >= ' + alert.download_count_max.to_s
      end

      if alert.duration_min != nil && alert.duration_min != ""
        where_exp += ' AND duration >= ' + alert.duration_min.floor.to_s
      end
      if alert.duration_max != nil && alert.duration_max != ""
        where_exp += ' AND duration <= ' + alert.duration_max.ceil.to_s
      end
      where_exp += ")"
      i += 1

    end

    recommended_tracks.where(where_exp).order('uploaded_at DESC').limit(10)
  end

  def get_summary_tracks
    #matched_tracks.where('processed = false')
    recommended_tracks.order('uploaded_at DESC').limit(10)
  end
end
