class SummaryMailer
  include Sidekiq::Worker
  sidekiq_options :queue => :summary_mailer, :retry => true

  def perform(user_id)
    @user = SoundcloudUser.find(user_id)
    @tracks = @user.get_summary_tracks
    AlertMailer.summary(@user).deliver
  end
end
