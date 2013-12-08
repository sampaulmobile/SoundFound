module SoundcloudUsersHelper

  def current_soundcloud_user=(user)
    @current_soundcloud_user = user
  end
  
  def current_soundcloud_user
    @current_soundcloud_user ||= current_user.soundcloud_user
  end
  
  def current_soundcloud_user?(user)
    user == current_soundcloud_user
  end

  def soundcloud_logged_in?
    current_user.soundcloud_connected
  end
  
end
