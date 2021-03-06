Cone::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  config.time_zone = 'Pacific Time (US & Canada)'

  # Cone Configs - over-ride
  config.twilio_sid = ENV['TWILIO_SID']
  config.twilio_auth = ENV['TWILIO_AUTH']
  config.twilio_number = ENV['TWILIO_NUMBER']
  config.gcm_key = ENV['GCM_KEY']
  config.mtb_key = ENV['MTB_KEY']
  config.mtb_secret = ENV['MTB_SECRET']
  config.mail_chimp_token = ENV['MAIL_CHIMP_TOKEN']
  config.mail_chimp_list = ENV['MAIL_CHIMP_LIST']

  config.twitter_consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.twitter_consumer_secret = ENV['TWITTER_CONSUMER_KEY']
  config.twitter_oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.twitter_oauth_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  
  
end
