module NewCommands
  class HelpCommand < NewCommand 
    description "Provides help for a command"

    command help: command_name do
      p NewCommand.commands
      NewCommand.commands.each do |c|
        p c.description
        event << c.description
      end
    end

    command help do
      event << "All help"
    end
  end
end