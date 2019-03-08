module Commands
  class NduggerCommand
    class << self
      def name
        :ndugger
      end

      def attributes
        {
            description: 'Duggerfy a message',
            usage: 'ndugger [message]'
        }
      end

      def command(event, *args)
        return if event.from_bot?

        message = args.join(' ')
        message.downcase.chars.map {|c| rand > 0.5 ? c.upcase : c}.join
      end
    end
  end
end