class AlertMailer < ActionMailer::Base
  default from: "soundfoundapp@gmail.com"

  add_template_helper(ApplicationHelper)

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.match.subject
  #
  def match(track, alert)
    @user = alert.soundcloud_user
    @track = track
    @alert = alert

    mail(to: "test@tester.com", subject: "New Match Found!")
    #mail(to: "#{@user.name} <#{@user.email}>", subject: "New Match Found!")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.summary.subject
  #
  def summary(sc_user)
    @tracks = sc_user.get_summary_tracks

    mail(to: "test@tester.com", subject: "Summary of Matches")
    #mail(to: "#{@user.name} <#{@user.email}>", subject: "Summary of Matches")
  end
end
