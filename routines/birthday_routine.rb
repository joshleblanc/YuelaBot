module Routines
  def birthday_routine(bot)
    Birthday.all.each do |bday|
      bot.send_message(bday.channel, bday.message)
    end
  end
end