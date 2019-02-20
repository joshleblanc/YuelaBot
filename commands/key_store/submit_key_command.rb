module Commands
  class SubmitKey
    class << self
      def name
        :submit_key
      end

      def attributes
        {
            usage: 'submit_key',
            description: 'Submit a game key to the store',
            aliases: [:sk]
        }
      end

      def command(event)
        unless event.server.nil?
          return "You need to do this in a private message!"
        end
        event.respond "What game are you submitting?"
        response = event.message.await!
        p response.message.content
        return "You took too long" unless response
        event.respond "What's the key?"
        response = event.message.await!
        p response.message.content
      end
    end
  end
end