module Commands
  class ClapCommand
    class << self
      def name
        :cl
      end

      def attributes
        {
            min_args: 1,
            description: 'meme 👏 review',
            usage: 'clap message'
        }
      end

      def command(event, *args)
        clap = '👏'
        event << args.join(clap)
      end
    end
  end
end