VeniceClient.configure do |config|
  config.access_token = ENV['OPENAI_API_KEY']
  config.debugging = Rails.env.development?
  # config.uri_base = 'https://api.venice.ai/api/v1'
end