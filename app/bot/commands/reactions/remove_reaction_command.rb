module Commands
  module Reactions
    class RemoveReactionCommand
      class << self
        def name
          :remove_reaction
        end

        def attributes
          {
              min_args: 1,
              max_args: 1,
              usage: 'remove_reaction [id]',
              description: 'Remove a reaction, given an ID',
              arg_types: [Integer],
              aliases: [:rr]
          }
        end

        def command(e, id)
          return if e.from_bot?
          begin
            ur = UserReaction.find_by(id: id, server: e.server.id)
            if ur 
              ur.destroy
              "Reaction #{id} deleted"
            else
              "No reaction found with id #{id}"
            end
          rescue StandardError => e
            e.message
          end
        end
      end
    end
  end
end