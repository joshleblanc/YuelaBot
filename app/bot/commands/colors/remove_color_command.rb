module Commands
  module Colors
    class RemoveColorCommand
      class << self
        def name
          :removecolor
        end

        def attributes
          {
              usage: 'removecolor color_name',
              description: 'Removes your color role',
              aliases: [:removecolour, :rc]
          }
        end

        def command(e, *name)
          return if e.from_bot?
          role = e.author.roles.find {|r| RoleColor.find_by(name: r.name, server: e.server.id) }
          return "You don't have a color role" unless role
          discord_role = e.author.roles.find { |r| r.name === role.name }
          if discord_role
            e.author.remove_role(discord_role)
            "Color role removed"
          else
            "You don't have that color role"
          end
        end
      end
    end
  end
end