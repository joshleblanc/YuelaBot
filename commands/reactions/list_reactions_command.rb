module Commands
  class ListReactionsCommand
    class << self
      def name
        [:lr, :list_reactions]
      end

      def attributes
        {
            max_args: 0,
            min_args: 0,
            usage: 'list_reactions',
            description: 'List all learned reactions'
        }
      end

      def command
        lambda do |event|
          user_reactions = UserReaction.all
          max = user_reactions.to_a.max { |ur| ur.regex.length }.regex.length
          event << "User reactions:"
          event << '```'
          event << UserReaction.all.map do |r|
            "(#{r.id}) #{r.regex.rjust(max)}: #{r.output}"
          end.join("\n")
          event << '```'
        end
      end
    end
  end
end