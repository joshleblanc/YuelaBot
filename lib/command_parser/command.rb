module CommandParser
  class Command
    def initialize(args)
      @args = args
    end

    def name
      @args.keys.join(':')
    end

    def args
      @args
    end
  end
end