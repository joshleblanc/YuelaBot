module Commands
  class DiceCommand
    class << self
      def name
        [:dice, :d]
      end
      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Return a random number between 1 and n',
            usage: 'dice [max]'
        }
      end

      def command(_, *args)
        Random.rand(args[0].to_i) + 1
      end
    end
  end
end
