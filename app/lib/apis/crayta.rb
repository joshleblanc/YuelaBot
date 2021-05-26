module Apis
  class Crayta
    BASE_URL = "https://devel.gate.live.us-central1-a930.hogsmill.ws.crayta.net"

    def discovery
      fetch discovery_url
    end

    private

    def discovery_url
      "#{BASE_URL}/discovery"
    end

    def fetch(url)
      response = RestClient.get url
      JSON.parse(response.body)
    end
  end
end