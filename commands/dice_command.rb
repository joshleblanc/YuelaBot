module Commands
  class DiceCommand
    class << self
      def name
        :dice
      end
      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Return a random number between 1 and n',
            usage: 'dice [max]'
        }
      end

      def command
        lambda do |_, *args|
          DiceCommand.new.run(args[0])
        end
      end
    end
    def run(num)
      Random.rand(num.to_i) + 1
    end
  end
end
