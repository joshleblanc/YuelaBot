module Commands
  class RemoveColorCommand
    class << self
      def name
        :removecolor
      end

      def attributes
        {
            min_args: 1,
            usage: 'removecolor color_name',
            description: 'Removes a color role',
            aliases: [:removecolour, :rc]
        }
      end

      def command(e, *name)
        name = name.join(' ')
        role = RoleColor.find_by(name: name, server: e.server.id)
        return "That color role doesn't exist" unless role
        discord_role = e.author.roles.find {|r| r.name === name}
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