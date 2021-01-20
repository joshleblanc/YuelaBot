module Apis
  class Twitch

    # POST https://id.twitch.tv/oauth2/token?client_id=uo6dggojyb8d6soh92zknwmi5ej1q2&client_secret=nyo51xcdrerl8z9m56w9w6wg&grant_type=client_credentials

    class << self
      def lease_time

      end

      def id
        ENV['TWITCH_CLIENT_ID']
      end

      def secret
        ENV['TWITCH_SECRET']
      end

      def token_expired?
        @expires_at.nil? || Time.now >= @expires_at
      end

      def access_token
        authenticate if token_expired?
        @access_token
      end

      def user(user_name)
        p user_name
        response = RestClient.get("https://api.twitch.tv/helix/users", {
          :params => {
            login: user_name
          },
          **authentication_headers
        })
        json = JSON.parse(response.body)
        p json
        json["data"].first
      end

      def authentication_headers
        {
          "Authorization" => "Bearer #{access_token}",
          "Client-Id" => id
        }
      end

      def subscribe(user_id, server)
        body = JSON.generate({
          "hub.callback": "https://yuela.moe/webhooks/twitch?user_id=#{user_id}&server=#{server}",
          "hub.mode": "subscribe",
          "hub.topic": "https://api.twitch.tv/helix/streams?user_id=#{user_id}",
          "hub.lease_seconds": least_time
        })

        headers = {
          "Content-Type" => "application/json",
        }.merge(authentication_headers)

        RestClient.post("https://api.twitch.tv/helix/webhooks/hub", body, headers)
      end

      def authenticate
        response = RestClient.post("https://id.twitch.tv/oauth2/token", {
          client_id: id,
          client_secret: secret,
          grant_type: "client_credentials"
        })
        body = JSON.parse(response.body)
        @expires_at = Time.now + body["expires_in"]
        @access_token = body["access_token"]
      end
    end
  end
end