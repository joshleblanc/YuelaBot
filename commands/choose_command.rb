module Commands
  class ChooseCommand
    class << self
      def name
        [:c, :choose]
      end

      def attributes
        {
          usage: 'choose [list of items]',
          min_args: 1,
          description: 'Choose from a list of items. Ignores "or"'
        }
      end

      def command
        lambda do |_, *choices|
          choices.join(' ').split(/,|\bor\b/).map(&:strip).delete_if(&:empty?).sample.squeeze(' ')
        end
      end
    end
  end
end