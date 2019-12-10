class NewCommand

    def initialize(event)
        @event = event
    end

    def event
        @event
    end

    def parse(str)
        parts = str.split(' ')
        parts.shift
        argument_str = parts.join(' ')
        args = argument_str.split(':').map(&:strip)
        args.each_slice(2) do |a, b|
            Command.define_method a do
                b
            end
        end
    end

    def run(str)
        parse(str)
        byebug
        instance_eval(&block)
    end

    class << self

        def process(event)
          message = event.message.content
          @commands.each do |command|
            command.run(message)
          end
        end

        def command(*args, &blk)
            @commands ||= []
            @commands.push({
              arguments: args[0],
              block: blk
            })
        end

        def description(str)
          define_method(:description) { str }
        end

        def method_missing(*args)
            args[0]
        end
    end
end