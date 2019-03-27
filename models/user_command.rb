class UserCommand < ApplicationRecord
  def run(event, *args)
    return if event.from_bot?

    test = args.join(' ')
    if input == '.*' || test.match(/#{input}/)
      test.gsub(/#{input}/, output)
    end
  end
end
