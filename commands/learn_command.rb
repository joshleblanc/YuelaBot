module Commands
  class LearnCommand
    class << self
      def name
        [:learn, :l]
      end

      def attributes
        {
          min_args: 2,
          description: 'Create a new command for Yuela',
          usage: 'l[earn] [name] "[output]" [regex]'
        }
      end

      def command
        lambda do |event, *args|
          parts = CSV.parse_line(args.join(' '), col_sep: ' ')
          name = parts[0]
          output = parts[1]
          input = parts[2] || '.*'

          command = UserCommand.first(name: name)
          if command
            'Command already exists'
          else
            UserCommand.create(name: name, input: input, output: output, created_at: Time.now, creator: event.author.username)
            BOT.command(name.to_sym) do |_, *args|
              test = args.join(' ')
              p test, /#{input}/, test.match(/#{input}/)
              if input == '.*' || test.match(/#{input}/)
                test.sub(/#{input}/, output)
              end
            end
            "Command #{name} learned"
          end
        end
      end
    end
  end
end