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