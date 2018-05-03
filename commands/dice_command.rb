module Commands
  def dice_command
    lambda do |event|
      num = event.message.content.split(' ')[1]
      event << Random.rand(num.to_i) + 1
    end
  end
end