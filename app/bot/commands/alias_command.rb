module Commands
  class AliasCommand
    class << self
      def name
        :alias
      end

      def attributes
        {
          description: <<~USAGE,
            Creates a new command that calls another command

            When an alias is called, any additional arguments added by the caller
            will be appended to the end of the end of the command.

            Example:

            !!alias superspread spread -a 10
            !!superspread test
            > t          e          s          t
          USAGE
          usage: "alias <new command name> <existing command> <arguments>",
          aliases: []
        }
      end

      def command(event, name, target, *args)
        return if event.from_bot?

        return "Command #{name} already exists" unless UserCommand.can_create?(name)
        return "Command #{target} doesn't exist" if UserCommand.can_create?(target)

        command = UserCommand.find_by(name: name)
        if command
          'Command #{name} already exists'
        else
          command = UserCommand.create(name: name, input: target, output: args.join(' '), creator: event.author.username, alias: true)
          BOT.command(name.to_sym, &command.method(:run))
          "Command #{name} learned"
        end
      end
    end
  end
end
