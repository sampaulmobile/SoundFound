class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  include SoundcloudUsersHelper

  helper_method :soundcloud_client

  def soundcloud_client
    return @soundcloud_client if @soundcloud_client
    @soundcloud_client = SoundcloudUser.soundcloud_client(:redirect_uri  => soundcloud_connected_url)
  end

  protected

    def after_sign_in_path_for(resource_or_scope)
      if current_soundcloud_user
        StreamUpdater.perform_async(current_soundcloud_user.id, 5)
        stream_url
      else
        root_url
      end
    end
    
    #Allow users to login with either SC username or email
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :password, :remember_me) }
    end

end
