module Commands
  class LastUsedReactionCommand
    class << self
      def name
        :last_used_reaction
      end

      def attributes
        {
          description: "Display the reaction last used in this channel",
          usage: "last_used_reaction",
          aliases: [:lur, :last]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        lur = LastUsedReaction.find_by(channel: event.channel.id)
        if lur
          <<~OUTPUT
            ```
            regex: #{lur.user_reaction.regex}
            output: #{lur.user_reaction.output}
            creator: #{lur.user_reaction.creator}
            chance: #{(lur.user_reaction.chance * 100).to_i}%
            first used: #{lur.user_reaction.created_at}
            last used: #{lur.user_reaction.updated_at}
            ```
          OUTPUT
        else
          "No reactions have been used in this channel"
        end
      end
    end
  end
end
