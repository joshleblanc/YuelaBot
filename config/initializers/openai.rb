OpenAI.configure do |config|
  config.access_token = ENV['OPENAI_API_KEY']
  config.uri_base = 'https://api.venice.ai/api/v1'
end