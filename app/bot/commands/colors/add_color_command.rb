module Commands
  module Colors
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
          return if e.from_bot?
          name, color = CSV.parse_line(args.join(' '), col_sep: ' ')
          color = color[1..-1] if color.start_with?('#')
          color = color.to_i(16)
          begin
            role = RoleColor.find_by(name: name, server: e.server.id)
            if role
              e.respond "That color role already exists! Do you want to overwrite it? (Y/N)"
              response = e.user.await!
              if response.message.content[0].downcase == 'y'
                role.update(color: color)
                e.server.roles.select {|r| r.name == name}.each {|r| r.color = Discordrb::ColourRGB.new(color)}
                "Role updated!"
              end
            else
              roles = e.server.roles.select {|r| r.name == name}
              if roles.empty?
                e.server.create_role(name: name, colour: Discordrb::ColourRGB.new(color), hoist: false, mentionable: false)
              else
                roles.each {|r| r.color = Discordrb::ColourRGB.new(color)}
              end
              RoleColor.create(name: name, color: "##{color}", server: e.server.id)
              "Color role created"
            end
          rescue StandardError => e
            p e.backtrace
            e.message
          end
        end
      end
    end
  end
end
