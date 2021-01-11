module Commands
  class SuggestCommand
    class << self
      def name
        :suggest
      end

      def attributes
        {
            description: "Suggest a feature for the bot",
            usage: "suggest something"
        }
      end

      def command(e, *terms)
        return if e.from_bot?

        suggestion = terms.join(' ')
        client = Octokit::Client.new(access_token: ENV['github_token'])
        body = <<~BODY
          Added by #{e.user.name} from #{e.server.name}##{e.channel.name}
          Context: https://discordapp.com/channels/#{e.server.id}/#{e.channel.id}/#{e.message.id}
        BODY
        client.create_issue('joshleblanc/yuelabot', suggestion, body, labels: "from-bot")
        e.respond "Suggestion added!"
      end
    end
  end
end
