module Commands
  class ForgetCommand
    class << self
      def name
        :forget
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Removes a user taught command',
            usage: 'f[orget] [learned command name]',
            permission_level: 1,
            aliases: [:f]
        }
      end

      def command(_, name)
        command = UserCommand.find_by(name: name)
        if command
          command.destroy
          BOT.remove_command(command.name.to_sym)
          "Command #{command.name} forgotten"
        else
          "Command #{name} does not exist"
        end
      end
    end
  end
end