module Commands
  class TriviaCommand
    class << self
      include Discordrb::Webhooks
      include Discordrb::Events

      def name
        :trivia
      end

      def token
        if @resp
          @resp
        else
          request_token
        end
      end

      def attributes
        {
            description: 'Start a trivia game',
            usage: 'trivia',
            aliases: [:t]
        }
      end

      def command(event, *args)
        p token
        question = get_question
        p question

        event.channel.send_embed do |embed|
          embed.title = "Trivia!"
          embed.colour = 0x1c8fe
          embed.description = CGI.unescapeHTML(question['question'])

          embed.footer = EmbedFooter.new(text: "#{question['category']} | #{question['difficulty']} | #{question['type']}")
        end
        winner = nil
        loop do
          answer = event.message.await!
          if answer.message.content.downcase == CGI.unescapeHTML(question['correct_answer']).downcase
            winner = answer.user
            break
          else
            answer.message.delete
          end
        end

        event.respond "#{winner&.name} got it!"
      end

      private

      def get_question
        response = RestClient.get("https://opentdb.com/api.php?amount=1&token=#{token}")
        result = JSON.parse(response.body)
        if result['response_code'] == 4
          refresh_token
          get_question
        else
          result['results'].first
        end
      end

      def refresh_token
        get_token("reset")
      end

      def request_token
        get_token("request")
      end

      def get_token(type)
        resp = RestClient.get("https://opentdb.com/api_token.php?command=#{type}")
        json = JSON.parse resp.body
        @resp = json['token']
      end
    end
  end
end
