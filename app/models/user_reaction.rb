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
#  times_used    :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Indexes
#
#  index_user_reactions_on_user_id  (user_id)
#
class UserReaction < ApplicationRecord
    has_many :last_used_reactions
    has_many :user_reaction_servers, dependent: :destroy
    has_many :servers, through: :user_reaction_servers
    belongs_to :user, required: false

    validates_presence_of :regex
    validates_presence_of :output
    validates_presence_of :servers

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
