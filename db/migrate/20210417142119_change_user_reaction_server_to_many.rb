class ChangeUserReactionServerToMany < ActiveRecord::Migration[6.1]
  def up
    UserReaction.find_each do |user_reaction|
      server = Server.where(external_id: user_reaction.server).first_or_create
      UserReactionServer.create(user_reaction: user_reaction, server: server)
    end
    remove_column :user_reactions, :server
  end

  def down
    add_column :user_reactions, :server, :string

    UserReaction.reset_column_information
    UserReaction.find_each do |user_reaction|
      server = user_reaction.servers.first
      user_reaction.update(server: server.external_id)
    end
  end
end
