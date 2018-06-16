class ImageChecker
  def self.check(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    is_image = false
    http.start do |http|
      is_image = http.header(uri.request_uri)['Content-Type']&.start_with? 'image'
    end
    is_image
  end
end