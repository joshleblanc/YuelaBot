module Routines
  def birthday_routine(bot)
    time = Time.now
    Birthday.all.each do |bday|
      if bday.month == time.month && bday.day == time.day
        config = BirthdayConfig.find_by(server: bday.server)
        bot.send_message(config.channel, "#{config.message} <@#{bday.user.id}>")
      end
    end
  end
end