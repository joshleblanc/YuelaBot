module Reactions
    class MagicReaction
        class << self
            include Discordrb::Webhooks

            def regex
                /\[\[(.+?)\]\]/
            end

            def attributes
                {
                    contains: self.regex
                }
            end

            def build_embed(card)
                embed = Embed.new(title: card.name)
                embed.color = 'black'
                embed.description = card.text
                embed.url = "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=#{card.multiverse_id}"
                embed.footer = EmbedFooter.new(text: card.set_name)
                embed.image = EmbedImage.new(url: card.image_url)
                embed
            end

            def command(event)
                matches = event.message.content.scan(self.regex)
                matches = matches.flatten.uniq
                matches.each do |m|
                    begin
                        cards = MTG::Card.where(name: %Q{#{m}}).all
                        card = cards.find(&:multiverse_id)

                        if card
                            event.respond nil, false, build_embed(card)
                        end
                    rescue NoMethodError
                        event << "Query failed for #{m}. Please try again later."
                    end
                end
            end
        end
    end
end 