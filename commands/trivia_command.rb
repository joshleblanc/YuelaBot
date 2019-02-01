module Commands
    class TriviaCommand
        include Discordrb::Webhooks
        include Discordrb::Events
        class << self
            

            def name
                [:trivia]
            end

            def attributes
                {
                    description: 'Start a trivia game',
                    usage: 'trivia'
                }
            end 

            def command
                lambda do |event, *args|
                    trivia_command = TriviaCommand.new(event)
                    trivia_command.run!
                end
            end
        end

        def initialize(event)
            @event = event
        end

        def run!
            @question = new_question
            @event.bot.add_await(:attempt, MessageEvent) do |event|
                if event.message.content == @question[:answer]
                    event << "#{event.user.name} got it!"
                end
            end

            embed = Embed.new(title: "Trivia")
            embed.description = @question[:question]
            @event.respond nil, false, embed
        end

        def new_question
            {
                question: "What's 2+2",
                answer: "4"
            }
        end
    end
end
