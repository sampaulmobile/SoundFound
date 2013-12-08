class Users::RegistrationsController < Devise::RegistrationsController
  
  before_filter :authenticate_user!,    except: [:new, :create]
  before_filter :correct_user,          only: [:edit, :update]
  before_filter :authenticate_admin!,   only: :destroy

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save

      sign_in @user
      #flash[:success] = "Thank you for signing up! You are now logged in."
    
      redirect_to soundcloud_client.authorize_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  
end
