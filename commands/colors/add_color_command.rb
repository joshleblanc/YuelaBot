module Commands
  class AddColorCommand
    class << self
      def name
        [:addcolor, :addcolour, :ac]
      end

      def attributes
        {
            min_args: 2,
            max_args: 2,
            usage: 'addcolor color_name hex_value',
            description: 'Create a role of name <color_name>, with color <hex_value>',
            permission_level: 1
        }
      end

      def command
        lambda do |e, *args|
          name, color = CSV.parse_line(args.join(' '), col_sep: ' ')
          color = color[1..-1] if color.start_with?('#')
          begin
            e.server.create_role(
              name: name,
              colour: color.to_i(16),
              hoist: true,
              mentionable: false,
              permissions: [],
              reason: 'Add Color Command'
            )
            RoleColor.create(name: name, color: "##{color}")
            e << "Color role created"
          rescue StandardError => e
            e.message
          end
        end
      end
    end
  end
end