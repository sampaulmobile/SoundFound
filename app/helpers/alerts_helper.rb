module AlertsHelper


  def alert_added?(alert)
    if user_session[:alerts] && user_session[:alerts].include?(alert.id.to_s)
      return ' bgcolor="green"'
    end
    return ""
  end

end
