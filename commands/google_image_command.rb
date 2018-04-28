module Commands
  def google_image_command
    lambda do |event|
      service = CustomsearchV1::CustomsearchService.new
      p service
    end
  end
end