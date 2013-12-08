class AlertsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter :authenticate_user!, only: [:create, :destroy]

  def create
    @alert = current_soundcloud_user.alerts.build(alert_params)
    if @alert.duration_min != nil 
      @alert.duration_min *= 60000
    end
    if @alert.duration_max != nil 
      @alert.duration_max *= 60000
    end

    # params[:alert][:alert_actions].each do |k, v|
    #   if v == "1"
    #     alert_action = @alert.actions.build(action_type: k)
    #     alert_action.save

    #     @alert.actionable = true
    #   end
    # end

    if @alert.save
      flash[:success] = "Alert created!"
      redirect_to stream_url
    else
      render 'new'
    end
  end

  def destroy
    @alert = current_soundcloud_user.alerts.find_by_id(params[:id])
    
    if @alert.destroy
      flash[:success] = "Alert deleted!"
    end

    puts "IN THE DESTRY MESTHODDD"

    redirect_to stream_url
  end

  def add
    if user_session[:alerts] == nil
      user_session[:alerts] = []
    end

    user_session[:alerts].push(params[:alert_id])

    if user_session[:alerts].uniq! == nil
      flash[:success] = "Added alert ##{params[:alert_id]}!"
      puts "Added alert ##{params[:alert_id]} to user_session"
    end

    respond_to do |format|
      format.html { redirect_to stream_url }
      format.js
    end
  end
  
  def remove
    if user_session[:alerts].delete(params[:alert_id]) != nil
      flash[:success] = "Removed alert ##{params[:alert_id]}!"
      puts "Removed alert ##{params[:alert_id]} from user_session"
    end

    respond_to do |format|
      format.html { redirect_to stream_url }
      format.js
    end
  end
  
  def delete
    puts "11 IN THE DELETEJjyy MESTHODDD with #{params[:alert_id]}"
    if user_session[:alerts].delete(params[:alert_id]) != nil
      flash[:success] = "Deleted alert ##{params[:alert_id]}!"
      puts "Removed alert ##{params[:alert_id]} from user_session"
    end

    puts "22 IN THE DELETEJjyy MESTHODDDwith #{params[:alert_id]}"
    current_soundcloud_user.alerts.find_by_id(params[:alert_id]).destroy
    
    respond_to do |format|
      format.html { redirect_to stream_url }
      format.js
    end
  end

  def clear
    count = user_session[:alerts].count
    user_session[:alerts] = []
      
    str = pluralize(count, "alert")
    flash[:success] = "Deleted #{str}"

    respond_to do |format|
      format.html { redirect_to stream_url }
      format.js
    end
  end


  private

    def alert_params
      params.require(:alert).permit(:play_count_min, :play_count_max,
                                    :like_count_min, :like_count_max,
                                    :download_count_min, :download_count_max,
                                    :duration_min, :duration_max,
                                    :downloadable, 
                                    :unplayed, :played)
    end
  
end
