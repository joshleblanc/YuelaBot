module Commands
  class AddReaction
    class << self
      def name
        [:ar, :add_reaction]
      end

      def attributes
        {
            min_args: 2,
            max_args: 3,
            usage: 'add_reaction [regex] [message] [chance]',
            description: 'Create a reaction for Yuela'
        }
      end

      def command
        lambda do |event, *args|
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
end