# == Schema Information
#
# Table name: crayta_rail_subscriptions
#
#  id         :bigint           not null, primary key
#  channel    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CraytaRailSubscription < ApplicationRecord
  include Discordrb::Webhooks

  def self.notify
    CraytaRail.where.not(name: "randomGamesRail").find_each do |rail|
      embed = Embed.new(title: "Crayta Rails", description: rail.name)
      current_games = rail.current_games
      previous_games = rail.previous_games

      new_games = current_games - previous_games
      removed_games = previous_games - current_games

      if new_games.empty? && removed_games.empty? 
        next
      end
      
      fields = []
      unless new_games.empty?
        fields << EmbedField.new(
          name: "Added",
          value: new_games.map(&:name).join(", ")
        )
      end

      unless removed_games.empty?
        fields << EmbedField.new(
          name: "Removed",
          value: removed_games.map(&:name).join(", ")
        )
      end
        
      embed.fields = fields
      embed.color = "#F870D4"
      embed.timestamp = Time.now

      find_each do |subscription|
        BOT.send_message subscription.channel, nil, false, embed 
      end
    end
  end
end
