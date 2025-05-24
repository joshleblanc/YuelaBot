# == Schema Information
#
# Table name: crayta_rails
#
#  id         :integer          not null, primary key
#  name       :string
#  current    :boolean
#  mode       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CraytaRail < ApplicationRecord
  has_many :crayta_rail_snapshots

  def current_games
    current_snapshot&.crayta_games || CraytaGame.none
  end

  def previous_games
    previous_snapshot&.crayta_games || CraytaGame.none
  end

  def previous_snapshot
    crayta_rail_snapshots.order(created_at: :desc).second
  end

  def current_snapshot
    crayta_rail_snapshots.order(created_at: :desc).first
  end

  def self.recently_updated
    find_by(name: "updatedGamesRail")
  end

  def self.recently_visited
    find_by(name: "recentlyVisited")
  end

  def self.frequently_visited
    find_by(name: "frequentlyVisited")
  end

  def self.random_games
    find_by(name: "randomGamesRail")
  end

  def self.active
    find_by(name: "activeGames")
  end

  def self.trending
    find_by(name: "currentlyTrending")
  end

  def self.most_visited
    find_by(name: "globallyMostVisited")
  end

  def self.curated
    find_by(name: "curated")
  end
  
  def self.snapshot
    discovery = Apis::Crayta.new.discovery
    rails = discovery["categories"]
    rails.each do |rail|
      crayta_rail = where(name: rail["name"]).first_or_create(mode: rail["mode"])
      crayta_rail.update(mode: rail["mode"])

      crayta_rail_snapshot = crayta_rail.crayta_rail_snapshots.build
      rail["list"]["items"].each do |game|
        crayta_game = CraytaGame.where(external_id: game["gameId"]).first_or_create(crayta_user: CraytaUser.where(external_id: game["ownerId"]).first_or_create(name: game["ownerName"]))
        
        crayta_game.update(
          name: game["name"],
          description: game["description"],
          publically_editable: game["publiclyEditable"],
          hidden: game["hidden"],
          system_game: game["systemGame"],
          copyable: game["copyable"],
          concealed: game["concealed"],
          archived: game["archived"],
          cover_image: game["coverImage"],
          up_votes: game["upVotes"],
          down_votes: game["downVotes"],
          visits: game["visits"],
          max_players: game["maxPlayers"],
          state_share_url: game["stateShareUrl"],
          blocked: game["blocked"],
          game_link: game["gameLink"],
          binned: game["binned"],
          external_created_at: game["created"],
          external_updated_at: game["updated"]
        )
        crayta_rail_snapshot.crayta_games << crayta_game
      end

      crayta_rail_snapshot.save
    end

    CraytaRailSubscription.notify
  end
end
