module Commands
  class AddReaction
    class << self
      def name
        :add_reaction
      end

      def attributes
        {
            usage: 'add_reaction [regex] [message] [chance]',
            description: 'Create a reaction for Yuela',
            aliases: [:ar]
        }
      end

      def command(event, *args)
        begin
          regex, output, chance = CSV.parse_line(args.join(' '), col_sep: ' ')
          chance = 1 if chance.nil?
          p regex, output, chance
          reaction = UserReaction.first(regex: regex)
          if reaction
            'Reaction already exists'
          else
            UserReaction.create(
                regex: regex,
                output: output,
                created_at: Time.now,
                creator: event.author.username,
                chance: chance.to_f
            )
            'Reaction created'
          end
        rescue
          "Something's not right - Check your input"
        end
      end
    end
  end
end