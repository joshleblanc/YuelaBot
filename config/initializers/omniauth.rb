Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :discord, ENV['DISCORD_CLIENT_ID'], ENV['DISCORD_SECRET_KEY'], scope: "email identify guilds"
end

OmniAuth.config.logger = Rails.logger
