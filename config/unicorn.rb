ENV["REDISTOGO_URL"] ||= "redis://redistogo:e4ca2dbf133f2eb85860c21e01d910dd@koi.redistogo.com:10105/"

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2 -C config/sidekiq.yml")

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end 

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  if defined?(Sidekiq)
    Sidekiq.configure_client do |config|
      config.redis = { url: ENV["REDISTOGO_URL"], :size => 1 }
    end
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV["REDISTOGO_URL"], :size => 5 }
    end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
