module Reactions
    class SoCommentReaction
      class << self
        include Discordrb::Webhooks
  
        def regex
          /https?:\/\/stackoverflow\.com\/questions\/\d+\/.+?#comment(\d+)_\d+/
        end
  
        def attributes
          {
              contains: self.regex
          }
        end
  
        def command
          lambda do |event|
            match_data = event.message.content.match(self.regex)
            url = match_data[0]
            messageid = match_data.captures[0]
  
            body = Nokogiri::HTML(open(url))
  
            message = body.at_css("#comment-#{messageid}")
            question = body.at_css('#question-header .question-hyperlink')
            user = message.at_css('a.comment-user')
            user_link = message.at_css('a.comment-user').attr('href')
            comment = message.at_css('span.comment-copy').text
            timestamp = body.at_css('span.comment-date span').attr('title')
            updoots = message.at_css('span.cool').text.to_i
  
            embed = Embed.new(title: question.text)
            embed.description = comment
            embed.color = '123123'.to_i(16)
            embed.url = url
            embed.timestamp = DateTime.parse(timestamp).to_time
            embed.author = EmbedAuthor.new(name: user.text, url: "https://stackoverflow.com#{user_link}")
            embed.footer = EmbedFooter.new(text: "#{updoots} upwelcomes")
            event.respond nil, false, embed
          end
        end
      end
    end
  end