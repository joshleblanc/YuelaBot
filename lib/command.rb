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
        instance_eval(&block)
    end

    class << self

        def command(*args, &blk)
            @@arguments = args[0]
            define_method(:block) { blk }
            args[0].keys do |k|
                attr_reader k
            end
        end

        def method_missing(*args)
            args[0]
        end

        def name
          @@arguments.keys[0]
        end
    end
end