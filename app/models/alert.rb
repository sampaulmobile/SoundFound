class Alert < ActiveRecord::Base

  belongs_to :soundcloud_user
  has_many :actions

  def process_track(t_id)
    t = SoundcloudTrack.find(t_id)
        
    if play_count_min != nil && play_count_min != -1 && play_count_min > t.play_count
      return false
    end

    if play_count_max != nil && play_count_max != -1 && play_count_max < t.play_count
      return false
    end
    
    if like_count_min != nil && like_count_min != -1 && like_count_min > t.favorite_count
      return false
    end

    if like_count_max != nil && like_count_max != -1 && like_count_max < t.favorite_count
      return false
    end
    
    if download_count_min != nil && download_count_min != -1 && 
      download_count_min > t.download_count
      return false
    end

    if download_count_max != nil && download_count_max != -1 && 
      download_count_max < t.download_count
      return false
    end
    
    if duration_min != nil && duration_min != -1 && duration_min > t.duration
      return false
    end

    if duration_max != nil && duration_max != -1 && duration_max < t.duration
      return false
    end
    
    actions.each do |a|
      a.perform_action(t.track_id)
    end
  end

end
