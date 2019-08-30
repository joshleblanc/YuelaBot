module Commands
  class ListReactionsCommand
    class << self
      include Discordrb::Webhooks
      include Discordrb::Events

      def name
        :list_reactions
      end

      def attributes
        {
            max_args: 0,
            min_args: 0,
            usage: 'list_reactions',
            description: 'List all learned reactions',
            aliases: [:lr]
        }
      end

      def command(event)
        return if event.from_bot?

        user_reactions = UserReaction.all
        if user_reactions.empty?
          event << "No reactions registered"
        else
          pagination_container = PaginationContainer.new("User Reactions", user_reactions, 10, event)
          pagination_container.paginate do |embed, index|
            left = index * 10
            right = left + 10
            embed.fields = user_reactions[left...right].map do |ur|
              EmbedField.new(name: "(#{ur.id} - #{ur.chance * 100}%) #{ur.regex}", value: ur.output)
            end
          end
          nil
        end
      end
    end
  end
end