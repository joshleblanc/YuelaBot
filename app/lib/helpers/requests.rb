module Helpers
  module Requests 
  
    def get_json(url)
      con = Faraday.new(url) do |f|
        f.response :json
        f.response :follow_redirects
      end

      con.get(url).body
    end

    def get(url)
      con = Faraday.new(url) do |f|
        f.response :follow_redirects
      end

      con.get(url).body
    end
  end
end