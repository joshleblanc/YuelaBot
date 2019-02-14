module Commands
  class AddColorCommand
    class << self
      def name
        :addcolor
      end

      def attributes
        {
            min_args: 2,
            max_args: 2,
            usage: 'addcolor color_name hex_value',
            description: 'Create a role of name <color_name>, with color <hex_value>',
            permission_level: 1,
            aliases: [:ac, :addcolour]
        }
      end

      def command(e, *args)
        name, color = CSV.parse_line(args.join(' '), col_sep: ' ')
        color = color[1..-1] if color.start_with?('#')
        begin
          role = RoleColor.first(name: name, server: e.server.id)
          if role
            e.user.await(:"role_color_create_confirmation#{e.user.id}") do |confirm_event|
              if confirm_event.message.content[0].downcase == 'y'
                role.update(color: color)
                e.server.roles.select {|r| r.name == name}.each {|r| r.color = Discordrb::ColourRGB.new(color)}
                confirm_event << "Role updated!"
              end
            end
            "That color role already exists! Do you want to overwrite it? (Y/N)"
          else
            roles = e.server.roles.select {|r| r.name == name}
            if roles
              roles.each {|r| r.color = Discordrb::ColourRGB.new(color)}
            else
              role = e.server.create_role(
                  name: name,
                  colour: Discordrb::ColourRGB.new(color),
                  hoist: false,
                  mentionable: false,
                  permissions: [],
                  reason: 'Add Color Command'
              )
              role.sort_above(e.user.highest_role)
            end
            RoleColor.create(name: name, color: "##{color}", server: e.server.id)
            "Color role created"
          end
        rescue StandardError => e
          e.message
        end
      end
    end
  end
end