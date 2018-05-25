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
            usage: 'add_reaction [regex] [message] [chance?]',
            description: "Create a reaction for Yuela"
        }
      end

      def command
        lambda do |event, regex, output
          |
          reaction = UserReaction.first(regex: regex)
          if reaction
            'Reaction already exists'
          else
            UserReaction.create(
                regex: regex,
                output: output,
                created_at: Time.now,
                creator: event.author.username
            )
            "Reaction created"
          end
        end
      end
    end
  end
end