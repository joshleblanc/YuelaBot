module Commands
  class AddReaction
    class << self
      def name
        :add_reaction
      end

      def attributes
        {
            usage: 'add_reaction [regex] [chance] [message]',
            description: 'Create a reaction for Yuela',
            aliases: [:ar]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        begin
          regex, chance, *output = args
          if regex.nil?
            return "You need to provide a regex to match"
          end
          chance = 1 if chance.nil?
          reaction = UserReaction.find_by(regex: regex, server: event.server.id)
          if reaction
            'Reaction already exists'
          else
            ur = UserReaction.create(
                regex: regex,
                output: output,
                created_at: Time.now,
                creator: event.author.username,
                chance: chance.to_f,
                server: event.server.id
            )
            "Reaction #{ur.id} created"
          end
        rescue StandardError => e
          e.message
        end
      end
    end
  end
end
