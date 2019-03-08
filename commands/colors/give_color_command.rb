module Commands
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
        role = e.author.roles.find {|r| RoleColor.first(name: r.name, server: e.server.id)}
        if role
          e.user.await(:"role_color_confirmation#{e.user.id}") do |confirm_event|
            if confirm_event.message.content[0].downcase == 'y'
              confirm_event.user.modify_roles(
                  e.server.roles.find {|r| r.name == name},
                  role
              )
              confirm_event << "Role #{role.name} removed, and role #{name} added"
            end
          end
          "Adding this role will remove #{role.name}, are you sure you want to continue? (Y/N)"
        else
          e.user.add_role(
              e.server.roles.find {|r| r.name == name},
          )
          "Role added!"
        end
      end
    end
  end
end