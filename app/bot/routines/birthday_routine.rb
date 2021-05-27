module Routines
  module BirthdayRoutine
    def birthday_routine(bot)
      time = Time.now
      year = time.year
      Birthday.all.each do |bday|
        if bday.month == time.month && bday.day == time.day && bday.year != year
          config = BirthdayConfig.find_by(server: bday.server)
          bday.update(year: year)
          bot.send_message(config.channel, "#{config.message} <@#{bday.user.id}>")
        end
      end
    end
  end
end