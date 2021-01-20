module Commands
  module Colors
    class GiveColorCommand
      class << self
        def name
          :color
        end

        def attributes
          {
              min_args: 1,
              max_args: 1,
              usage: 'color color_name',
              description: 'Give yourself a role that changes the color of your name',
              aliases: [:colour, :gc, :givecolor, :givecolour]
          }
        end

        def command(e, *name)
          return if e.from_bot?

          name = name.join(' ')
          return "That color role doesn't exist" unless RoleColor.find_by(name: name, server: e.server.id)
          role = e.author.roles.find {|r| RoleColor.find_by(name: r.name, server: e.server.id) }
          new_role = e.server.roles.find { |r| r.name == name }
          if role
            if role == new_role
              "You already have this color"
            else
              e.user.await(:"role_color_confirmation#{e.user.id}") do |confirm_event|
                if confirm_event.message.content[0].downcase == 'y'
                  confirm_event.user.modify_roles(
                      new_role,
                      role
                  )
                  confirm_event << "Role #{role.name} removed, and role #{name} added"
                end
              end
              "Adding this role will remove #{role.name}, are you sure you want to continue? (Y/N)"
            end
          else
            if role.position < e.user.highest_role
              role.sort_above(e.user.highest_role)
            end
            e.user.add_role(new_role)
            "Role added!"
          end
        end
      end
    end
  end
end
