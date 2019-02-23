module Commands
  class TriviaCommand
    class << self
      include Discordrb::Webhooks
      include Discordrb::Events

      def name
        :trivia
      end

      def attributes
        {
            description: 'Start a trivia game',
            usage: 'trivia',
            aliases: [:t]
        }
      end

      def command(event)
        @event = event
        @scores = {}
        @max_points = 10
        @duration = 30
        @show_hint = false
        @stop = false
        loop do
          @question = get_question
          @answer = @question['answer'].gsub(/<i>(.+)<\/i>/, "\\1")
          p @answer

          question_message = send_question

          answer_loop = start_answer_loop
          time_limit_thread = time_limit_routine(answer_loop, question_message)

          if answer_loop.join.value
            handle_correct_answer
          else
            handle_no_correct_answer
          end
          time_limit_thread.terminate

          if done?
            send_scores
            break
          end
        end
      end

      private

      def get_question
        response = RestClient.get("jservice.io/api/random")
        result = JSON.parse(response.body)
        question = result.first
        if question['invalid_count']
          get_question
        else
          question
        end
      end

      def time_limit_routine(answer_loop, question_message)
        Thread.new do
          step = @duration / 3
          sleep step
          hint = make_hint
          question_embed = question_message.embeds[0]
          new_embed = Embed.new(
              title: question_embed.title,
              color: question_embed.color,
              fields: question_embed.fields.map { |f| EmbedField.new(name: f.name, value: f.value)},
              footer: EmbedFooter.new(text: hint)
          )
          question_message = question_message.edit(nil, new_embed)

          sleep step
          p update_hint(hint)
          new_embed.footer = EmbedFooter.new(text: update_hint(hint))
          question_message.edit(nil, new_embed)

          sleep step
          new_embed.footer = EmbedFooter.new(text: update_hint(hint, 1))
          question_message.edit(nil, new_embed)
          answer_loop.terminate
        end
      end

      def send_scores
        sorted_scores = @scores.sort_by { |_, v| v[:score] }.reverse
        send_embed do |embed|
          final_results = StringIO.new
          sorted_scores.each do |k, v|
            final_results.puts "**<@#{k}>** got #{v[:score]} points"
          end
          embed.fields = [
              EmbedField.new(name: "Final Scores:", value: final_results.string)
          ]
        end
      end

      def done?
        someone_won? || game_stopped?
      end

      def game_stopped?
        @stop
      end

      def someone_won?
        (@winner && @scores[@winner&.id][:score] == @max_points)
      end

      def handle_correct_answer
        @scores[@winner&.id] ||= { score: 0 }
        @scores[@winner&.id][:name] = @winner&.name
        @scores[@winner&.id][:score] += 1

        send_embed do |embed|
          embed.description = "<@#{@winner&.id}> got it! The answer was: **#{@answer}**"
        end
      end

      def handle_no_correct_answer
        send_embed do |embed|
          embed.description = "Time's up! The answer was: **#{@answer}**"
        end
      end

      def start_answer_loop
        Thread.new do
          loop do
            response = @event.message.await!
            if response.message.content == '!!stop' && !@stop
              @stop = true
              send_stop_message
            else
              response.message.delete
            end

            if response.message.content.downcase == CGI.unescapeHTML(@answer).downcase
              @winner = response.user
              break
            end
          end
          true
        end
      end

      def send_question
        send_embed do |embed|
          embed.fields = [
              EmbedField.new(name: "Category", value: @question['category']['title']),
              EmbedField.new(name: "Question", value: CGI.unescapeHTML(@question['question']))
          ]
          embed.description = "You can stop trivia with !!stop"
        end
      end

      def send_stop_message
        send_embed do |embed|
          embed.description = "Okay, stopping after this question"
        end
      end

      def make_hint
        @answer.chars.map do |c|
          if c == " "
            "  "
          elsif rand < 0.10
            "#{c} "
          else
            "_ "
          end
        end.join
      end

      def update_hint(hint, chance = 0.5)
        p hint, hint.gsub("  ", " "), hint.gsub("  ", " ").gsub(/(\w) /, "\1")
        hint = hint.gsub("  ", " ").gsub(/(\w) /, "\\1")
        hint.chars.map.with_index do |c, i|
          if c == "_" && rand < chance
            "#{@answer[i]} "
          elsif c == " "
            "  "
          else
            "#{c} "
          end
        end.join
      end

      def send_embed
        @event.channel.send_embed do |embed|
          embed.title = "Trivia!"
          embed.color = 0x1c8fe
          yield embed
        end

      end
    end
  end
end
