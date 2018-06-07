module Commands
  class InfoCommand
    class << self
      def name
        [:info]
      end

      def attributes
        {
          min_args: 1,
          max_args: 1,
          description: 'Provides information about a user taught command',
          usage: 'i[nfo] [learned command name]'
        }
      end

      def command
        lambda do |_, name|
          command = UserCommand.first(name: name)
          if command
            sio = StringIO.new
            sio << "Command #{command.name}\n"
            sio << "Input: #{command.input}\n"
            sio << "Output: #{command.output}\n"
            sio << "created by #{command.creator} on #{command.created_at.strftime("%F")}"
            sio.string
          else
            "Command #{name} does not exist"
          end
        end
      end
    end
  end
end