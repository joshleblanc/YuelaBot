module Commands
  class SourceCommand
    class << self
      include Discordrb::Webhooks

      def name
        :source
      end

      def attributes
        {
          max_args: 1,
          min_args: 1,
          description: "Show the source for a command",
          usage: "source <command>",
          aliases: [:code]
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
          data = File.read(location).gsub('```') { "`​`​`" }.lines # The replacement here has zero-width spaces between the tildes
          pagination_container = PaginationContainer.new(File.basename(location), data, 38, e)
          pagination_container.paginate do |embed, index|
            range_start = index * 38
            range_end = range_start + 50
            embed.description = "```ruby\n"
            embed.description << data[range_start...range_end].join
            embed.description << "\n```"
          end
          nil
        else
          "No command found for #{command_str}"
        end
      end
    end
  end
end