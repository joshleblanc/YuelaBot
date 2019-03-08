module Commands
  class GithubCommand
    class << self
      def name
        :github
      end

      def attributes
        {
            min_args: 0,
            max_args: 0,
            description: 'Returns the github link',
            usage: 'github'
        }
      end

      def command(event)
        return if event.from_bot?

        'https://github.com/HorizonShadow/YuelaBot'
      end
    end
  end
end