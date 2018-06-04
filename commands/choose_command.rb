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
        lambda do |e, *choices|
          choices = choices.delete_if { |c| c.downcase == 'or' }
          choices.sample.chomp ','
        end
      end
    end
  end
end