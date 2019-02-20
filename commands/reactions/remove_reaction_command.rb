module Commands
  class RemoveReactionCommand
    class << self
      def name
        :remove_reaction
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            usage: 'remove_reaction [id]',
            description: 'Remove a reaction, given an ID',
            arg_types: [Integer],
            aliases: [:rr]
        }
      end

      def command(_, id)
        begin
          UserReaction.find(id).destroy
          "Reaction #{id} deleted"
        rescue StandardError => e
          e.message
        end
      end
    end
  end
end