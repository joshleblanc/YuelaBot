module Commands
  class SubmitKey
    class << self
      def name
        :submit_key
      end

      def attributes
        {
            usage: 'submit_key',
            description: 'Submit a game key to the store',
            aliases: [:sk]
        }
      end

      def command(event)
        if event.server.nil?
          return "Initiate this command in a server"
        else
          event.respond "Check your pms!"
        end
        game_key = GameKey.new(server: event.server.id)

        event.user.pm "You can cancel this at any time by saying 'stop'"
        event.user.pm "What game are you submitting?"

        response = nil
        loop do
          response = event.user.await!
          break if response.server.nil?
        end
        return "Game key submission cancelled" if response.message.content == 'stop'
        game_key.name = response.message.content

        event.user.pm "What's the key?"
        loop do
          response = event.user.await!
          break if response.server.nil?
        end
        return "Game key submission cancelled" if response.message.content == 'stop'
        game_key.key = response.message.content
        game_key.save
        event.user.pm "Key submitted!"
      end
    end
  end
end