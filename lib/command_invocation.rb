class CommandInvocation
  def initialize(args, &blk)
    @args = args
    @blk = blk
  end

  def run(message)
    return unless message.start_with? "!!"
    command_name = message.match(/!!(.+) ?/)[1]

    return unless command_name == name
    new.run(message)
  end

  def can_run(str)
    
  end

  def name
    @args[0].keys[0].to_s
  end
end