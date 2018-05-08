module Commands
  class ForgetCommand
    class << self
      def name
        [:f, :forget]
      end

      def attributes
        {
          min_args: 1,
          max_args: 1,
          description: 'Removes a user taught command',
          usage: 'f[orget] [learned command name]'
        }
      end

      def command
        lambda do |event, *args|
          return "No" unless event.user.id.to_s == CONFIG['admin_id']
          command = UserCommand.first(name: args[0])
          if command
            command.destroy
            BOT.remove_command(command.name.to_sym)
            "Command #{command.name} forgotten"
          else
            "Command #{args[0]} does not exist"
          end
        end
      end
    end
  end
end