module Commands
  class ListColorsCommand
    class << self
      def name
        :listcolors
      end

      def attributes
        {
            min_args: 0,
            max_args: 0,
            usage: 'listcolors',
            description: 'See a list of available color roles',
            aliases: [:lc, :listcolours, :colours, :colors]
        }
      end

      def command(e)
        colors = RoleColor.all(server: e.server.id)
        e << "Available colors:"
        e << '```'
        colors.each do |c|
          e << "#{c.name} #{c.color}"
        end
        e << '```'
      end
    end
  end
end