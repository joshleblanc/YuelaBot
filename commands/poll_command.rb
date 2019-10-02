module Commands
  class PollCommand
    class << self
      def name
        :poll
      end

      def attributes
        {
            usage: "poll",
            description: "Create a poll",
            aliases: [:p]
        }
      end

      def command(event)
        return if event.from_bot?
        poll = PollCommand.new(event)
        event.user.pm "What question do you want to ask? Cancel with !!cancel"
        return if poll.get_question == '!!cancel'
        event.user.pm "Enter the options now. Stop with !!done"
        loop do
          break unless poll.get_answer
        end

        event.user.pm "Thanks, I've sent your poll to the channel"
        poll.run
      end
    end

    def initialize(event)
      @event = event
      @question = nil
      @options = []
    end

    def get_question
      loop do
        response = @event.user.await!
        if response.server.nil?
          @question = response.message.content
          break
        end
      end
      @question
    end

    def get_answer
      loop do
        answer = @event.user.await!
        if answer.server.nil?
          if answer.message.content == "!!done"
            return false
          else
            @options << {
                key: (@options.count + 65).chr,
                content: answer.message.content,
                votes: 0
            }
          end
        end
      end
    end

    def run
      voters = []
      votes = 0
      @event.channel.send_embed("Poll will end in 60 seconds!") do |embed|
        embed.title = @question
        options = @options.map do |o|
          "#{o[:key]}) #{o[:content]}"
        end.join("\n")
        embed.add_field(name: "Options", value: options)
      end
      voting_thread = Thread.new do
        loop do
          response = @event.channel.await!
          next if voters.include? response.user.id
          option = @options.find { |o| o[:key].downcase === response.message.content.downcase }
          if option
            option[:votes] += 1
            votes += 1
            voters << response.user.id
          end
        end
      end

      Thread.new do
        sleep 60
        voting_thread.terminate
      end

      voting_thread.join

      @event.channel.send_embed("Poll's finished! Here are the results") do |embed|
        embed.title = @question

        results = @options.sort_by { |o| o[:votes] }.reverse.map do |o|
          if votes == 0
            percent = 0.0
          else
            percent = ((o[:votes] / votes.to_f) * 100).round
          end
          "#{o[:key]}) #{o[:content]} **#{percent}%**"
        end.join("\n")
        embed.add_field(name: "Results", value: results)
      end

    end
  end
end