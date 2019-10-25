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
        message.downcase.chars.each_with_index.map {|c,i| (i % 2 === 0) ? c.upcase : c.downcase}.join
      end
    end
  end
end