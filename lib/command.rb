class NewCommand
    class << self
        def process(event)
          message = event.message.content
          @commands.each do |command|
            command_copy = command.clone
            command_copy.event = event
            command_copy.run(message)
          end
        end

        def command(*args, &blk)
            @commands ||= []
            @commands.push(NewCommand.new(args[0], blk))
        end

        def description(str)
          define_method(:description) { str }
        end

        def method_missing(*args)
            args[0]
        end
    end

  attr_writer :event
  def initialize(args, blk)
    @args = args
    @blk = blk
  end

  def run(message)
    return unless message.start_with? "!!"
    command_name = message.match(/!!(.+?):? /)[1]
    return unless command_name == name
    can_run = parse(message)
    instance_eval(&@blk) if can_run
  end

  def name
    @args.keys[0].to_s
  end

  def event
    @event
  end

  private

  def parse(str)
    str = str[2..-1]
    parts = str.split(' ')
    argument_str = parts.join(' ')
    args = argument_str.split(':').map(&:strip)
    args.each_slice(2) do |a, b|
        method_name = @args[a.to_sym]
        if method_name
          define_singleton_method method_name do
            b
          end
        else
          return false
        end
    end
    true
  end
end