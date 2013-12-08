class UsersController < ApplicationController
  
  before_filter :authenticate_user!,    except: [:new, :create]
  before_filter :correct_user,          only: [:edit, :update]
  before_filter :authenticate_admin!,   only: :destroy

  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save

      sign_in @user
      #flash[:success] = "Thank you for signing up! You are now logged in."
    
      #redirect_to soundcloud_client.authorize_url
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def update_tracks
    @user = current_user
    @user.update_own_tracks
    redirect_to @user
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
    
    def user_params
      params.require(:user).permit(:username, :email, :first_name, :last_name, 
                                   :password, :password_confirmation)
    end

    def correct_user
      @user = !params[:id].nil? ? User.find(params[:id]) : current_user
      redirect_to(root_path) unless current_user?(@user)
    end
end
