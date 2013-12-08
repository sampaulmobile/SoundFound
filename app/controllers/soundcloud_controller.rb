class SoundcloudController < ApplicationController

  def connect
    @user = User.new(user_params)
    if @user.save
      sign_in @user
    
      redirect_to soundcloud_client.authorize_url
    end

    redirect_to root_url
  end

  def connected
    if params[:error].nil?
      soundcloud_client.exchange_token(:code => params[:code])
      me = soundcloud_client.get("/me")

      current_user.update_column(:soundcloud_connected, true)
      current_user.update_column(:soundcloud_user_id, me.id)
      current_user.update_column(:username, me.username)

      is_old = SoundcloudUser.exists?(user_id: me.id)
      current_sc_user = SoundcloudUser.find_or_create_by_user_id(me.id)

      current_sc_user.update_column(:username, me.username)
      current_sc_user.update_column(:access_token, soundcloud_client.access_token)
      current_sc_user.update_column(:refresh_token, soundcloud_client.refresh_token)
      current_sc_user.update_column(:expires_at, soundcloud_client.expires_at)

      StreamUpdater.perform_async(current_sc_user.id, 10)
    end

    redirect_to stream_url
  end

  def disconnect
    current_user.update_column(:soundcloud_connected, false)
    redirect_to root_url
  end
  
  def index
  end

  def match
    MatchMailer.perform_async(params[:track_id], params[:alert_id])
    redirect_to stream_url
  end
  
  def summary
    SummaryMailer.perform_async(params[:user_id])
    redirect_to stream_url
  end
  
  def download
    send_file params[:filepath], filename: params[:filename], :disposition => 'attachment'
  end
  
  private

    def soundcloud_client
      return @soundcloud_client if @soundcloud_client
      @soundcloud_client = SoundcloudUser.soundcloud_client(:redirect_uri  => soundcloud_connected_url)
    end
    
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
