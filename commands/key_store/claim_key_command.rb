module Commands
  class ClaimKey
    class << self
      def name
        :claim_key
      end

      def attributes
        {
            usage: 'claim_key <id>',
            description: "Claim a key",
            aliases: [:ck, :claim],
            min_args: 1,
            max_args: 1
        }
      end

      def command(event, id)
        return if event.from_bot?

        if event.server.nil?
          return "Initiate this command in a server"
        end
        game_key = GameKey.find_by(id: id, server: event.server.id)
        if game_key
          response = StringIO.new
          response.puts "You've claimed a key!"
          response.puts "You claimed: #{game_key.name}"
          response.puts "The key is: #{game_key.key}"
          game_key.destroy
          event.user.pm response.string
        else
          event.respond "No such key exists"
        end
      end
    end
  end
end