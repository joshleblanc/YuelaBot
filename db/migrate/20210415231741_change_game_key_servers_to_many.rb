class ChangeGameKeyServersToMany < ActiveRecord::Migration[6.1]
  def up
    GameKey.find_each do |game_key|
      server = Server.where(external_id: game_key.server).first_or_create
      GameKeyServer.create(game_key: game_key, server: server)
    end
    remove_column :game_keys, :server
  end

  def down
    add_column :game_keys, :server, :string

    GameKey.reset_column_information
    GameKey.find_each do |game_key|
      server = game_key.servers.first
      game_key.update(server: server.external_id)
    end
  end
end
