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
        scores = {}
        max_points = 10
        duration = 10
        stop = false
        loop do
          question = get_question
          p question['correct_answer']
          event.channel.send_embed do |embed|
            embed.title = "Trivia!"
            embed.colour = 0x1c8fe
            embed.description = CGI.unescapeHTML(question['question'])
            embed.footer = EmbedFooter.new(text: "#{question['category']} | #{question['difficulty']} | #{question['type']}")
          end
          winner = nil
          game_thread = Thread.new do
            loop do
              answer = event.message.await!
              if answer.message.content == '!!stop' && !stop
                stop = true
                event.channel.send_embed do |embed|
                  embed.title = "Trivia!"
                  embed.description = "Okay, stopping after this question"
                  embed.colour = 0x1c8fe
                end
              else
                answer.message.delete
              end

              if answer.message.content.downcase == CGI.unescapeHTML(question['correct_answer']).downcase
                winner = answer.user
                break
              end
            end
            true
          end
          Thread.new do
            sleep duration
            game_thread.terminate
          end
          if game_thread.join.value
            scores[winner&.id] ||= { score: 0 }
            scores[winner&.id][:name] = winner&.name
            scores[winner&.id][:score] += 1
            event.channel.send_embed do |embed|
              embed.title = "Trivia!"
              embed.description = "<@#{winner&.id}> got it! The answer was: **#{question['correct_answer']}**"
              embed.colour = 0x1c8fe
            end
          else
            event.channel.send_embed do |embed|
              embed.title = "Trivia!"
              embed.description = "Time's up! The answer was: **#{question['correct_answer']}**"
              embed.colour = 0x1c8fe
            end
          end
          if (winner && scores[winner&.id][:score] == max_points) || stop
            sorted_scores = scores.sort_by { |_, v| v[:score] }.reverse
            event.channel.send_embed do |embed|
              embed.title = "Trivia Complete!"
              final_results = StringIO.new
              sorted_scores.each do |k, v|
                final_results.puts "**<@#{k}>** got #{v[:score]} points"
              end
              embed.description = final_results.string
            end
            break
          end
        end
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
