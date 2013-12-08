class StreamUpdater
  include Sidekiq::Worker
  sidekiq_options :queue => :stream_updater, :retry => true

  def perform(id, count)
    SoundcloudUser.find(id).update_stream(count)
  end
end
