module Commands
  def github_command
    lambda do |event|
      event << 'https://github.com/HorizonShadow/YuelaBot'
    end
  end
end