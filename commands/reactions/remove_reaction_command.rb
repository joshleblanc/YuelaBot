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
          UserReaction.get(id).destroy
          "Reaction #{id} deleted"
        rescue
          "Mr. Stark, I don't feel so good"
        end
      end
    end
  end
end