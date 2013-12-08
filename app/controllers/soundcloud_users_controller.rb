class SoundcloudUsersController < ApplicationController

  before_filter :authenticate_admin!, only: :destroy

  def new
    @soundcloud_user = SoundcloudUser.new
  end

  def create
  end

  def show
  end

  def stream
    @alert = Alert.new
    @recommended_tracks = current_soundcloud_user.apply_alerts(user_session[:alerts])

    @new_alert = Alert.new
  end
  
  def index
    @soundcloud_users = SoundcloudUser.paginate(page: params[:page])
  end
  
  def update_user
    current_sc_user = SoundcloudUser.find(params[:id])
    if current_sc_user
      StreamUpdater.perform_async(params[:id], 10)
    end

    redirect_to stream_url
  end

  def like_track
    current_soundcloud_user.like_track(params[:track_id])
    redirect_to stream_url
  end
  
  def unlike_track
    current_soundcloud_user.unlike_track(params[:track_id])
    redirect_to stream_url
  end
  
  def destroy
    SoundcloudUser.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to soundcloud_users_url
  end
  
end
