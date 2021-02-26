# == Schema Information
#
# Table name: user_reactions
#
#  id            :bigint           not null, primary key
#  chance        :float            default(1.0)
#  creator       :string
#  first_used_at :datetime
#  last_used_at  :datetime
#  output        :text
#  regex         :string
#  server        :bigint
#  times_used    :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class UserReaction < ApplicationRecord
    has_many :last_used_reactions

    def trigger(event)
        adjusted_output = output.sub(":user", event.author.mention)
        event.respond(event.message.content.sub(/#{regex}/, adjusted_output))

        lur = LastUsedReaction.where(channel: event.channel.id).first_or_initialize
        lur.update(user_reaction: self)

        self.first_used_at = Time.now if first_used_at.nil?
        self.last_used_at = Time.now
        increment :times_used, 1
        save
    end
end
