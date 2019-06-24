module Commands
  class SourceCommand
    class << self
      def name
        :source
      end

      def attributes
        {
          max_args: 1,
          min_args: 1,
          description: "Show the source for a command",
          usage: "source <command>"
        }
      end

      def command(e, *args)
        return if e.from_bot?

        command_str = args.first.to_sym
        command = Commands.constants.find do |c|
          command = Commands.const_get(c)
          command.is_a?(Class) && [command.name, *command.attributes[:aliases]].include?(command_str)
        end
        if command
          command_class = Commands.const_get(command)
          location = command_class.method(:name).source_location.first
          p location
          result = "```ruby\n"
          result << File.read(location)
          result << "\n```"
          result
        else
          "No command found for #{command_str}"
        end
      end
    end
  end
end