ENV["REDISTOGO_URL"] ||= "redis://redistogo:e4ca2dbf133f2eb85860c21e01d910dd@koi.redistogo.com:10105/"

require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"], :size => 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"], :size => 3 }
end

