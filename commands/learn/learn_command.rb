module Commands
  class LearnCommand
    class << self
      def name
        [:learn, :l]
      end

      def attributes
        {
          min_args: 2,
          max_args: 3,
          description: 'Create a new command for Yuela',
          usage: 'l[earn] [name] [output] [regex]'
        }
      end

      def command
        lambda do |event, name, output, *rest|
          input = rest.join || '.*'
          command = UserCommand.first(name: name)
          if command
            'Command already exists'
          else
            command = UserCommand.create(name: name, input: input, output: output, created_at: Time.now, creator: event.author.username)
            BOT.command(name.to_sym, &command.run)
            "Command #{name} learned"
          end
        end
      end
    end
  end
end