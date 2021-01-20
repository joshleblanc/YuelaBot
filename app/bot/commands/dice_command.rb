module Commands
  class DiceCommand
    class << self
      include Middleware

      def name
        :dice
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Return a random number between 1 and n',
            usage: 'dice nDs - dice 1d6 would roll 1 six sided dice',
            aliases: [:d, :roll]
        }
      end

      def command(e, *args)
        return if e.from_bot?

        num_dice, num_sides = args[0].downcase.split('d')
        if num_sides.nil? || num_dice.nil?
          num_dice = 1
          num_sides = 6
        end

        rolls = []
        num_dice.to_i.times.each do 
          rolls << Random.rand(num_sides.to_i) + 1
        end

        formatted_rolls = rolls.map do |r| 
          r.to_s.rjust(num_sides.size, " ")
        end.join("\t")
        if formatted_rolls.size < 1990
          <<~RETURN
          ```
          #{formatted_rolls}
          ---
          total: #{rolls.sum}
          ```
        RETURN
        else
          rolls.sum
        end
      end
    end
  end
end
