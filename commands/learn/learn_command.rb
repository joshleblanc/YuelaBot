module Commands
  class LearnCommand
    class << self
      def name
        :learn
      end

      def attributes
        {
            description: 'Create a new command for Yuela',
            usage: 'l[earn] [name] [output] [regex]',
            aliases: [:l]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        name, output, *rest = CSV.parse_line(args.join(' '), col_sep: ' ')
        input = rest.join || '.*'
        return "That's not quite right" unless name && output && input

        existing_command = Commands.constants.find do |c|
          command = Commands.const_get(c)
          command.is_a?(Class) && [command.name, *command.attributes[:aliases]].include?(name.to_sym)
        end
        blacklisted_commands = ['help']
        return "Built-in command #{name} already exists." if existing_command || blacklisted_commands.include?(name)

        command = UserCommand.find_by(name: name)
        if command
          'Command already exists'
        else
          command = UserCommand.create(name: name, input: input, output: output, creator: event.author.username)
          BOT.command(name.to_sym, &command.method(:run))
          "Command #{name} learned"
        end
      end
    end
  end
end
