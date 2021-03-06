module Commands
  module Learn
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

          return "Built-in command #{name} already exists." unless UserCommand.can_create?(name)

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
end
