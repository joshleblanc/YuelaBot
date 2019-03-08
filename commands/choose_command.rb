module Commands
  class ChooseCommand
    class << self
      def name
        :choose
      end

      def attributes
        {
            usage: 'choose [list of items]',
            min_args: 1,
            description: 'Choose from a list of items. Ignores "or"',
            aliases: [:c]
        }
      end

      def command(e, *choices)
        return if e.from_bot?

        choices.join(' ').split(/,|\bor\b/).map(&:strip).delete_if(&:empty?).sample.squeeze(' ')
      end
    end
  end
end