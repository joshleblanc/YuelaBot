require_relative '../lib/helpers/markdown'

module Reactions
    class SoCommentReaction
      class << self
        include Discordrb::Webhooks
        include Helpers

        def counters
          [
            "upwelcomes",
            "updoots",
            "upmichaels",
            "minorities oppressed",
            "pronouns used incorrectly",
            "mods banned without warning",
            "attack helicopters",
            "upset folk",
            "boltclocks",
            "CoC revisions",
            "stockholders satisfied",
            "twitter users offended",
            "autopsies performed",
            "networks improved",
            "surveys performed",
            "chatrooms killed",
            "mods resigned",
            "users no longer allowed to talk to Yvette",
            "ragequits",
            "REEEEEEEE",
            "accounts deleted",
            "faqs deleted",
            "users gone full retard",
            "shall not pass"
          ]
        end

        def regex
          /https?:\/\/(?:.*\.)?stack(?:overflow|exchange)\.com\/questions\/\d+\/.+?#comment(\d+)_(\d+)/
        end

        def no_inline_regex
          /<(#{regex})>/
        end

        def attributes
          {
              contains: self.regex
          }
        end

        def command(event)
          return if event.from_bot?

          match_data = event.message.content.match(self.regex)
          url = match_data[0]
          messageid = match_data.captures[0]

          p url, messageid, match_data.captures[1], match_data.captures
          uri = URI.parse(url)
          body = Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
          comments = Nokogiri::HTML(open("https://#{uri.hostname}/posts/#{match_data.captures[1]}/comments"), nil, Encoding::UTF_8.to_s)

          message = comments.at_css("#comment-#{messageid}")
          question = body.at_css('#question-header .question-hyperlink')
          user = message.at_css('a.comment-user')
          user_link = message.at_css('a.comment-user').attr('href')
          comment = Nokogiri::HTML(html_to_md(message.at_css('span.comment-copy').inner_html), nil, Encoding::UTF_8.to_s).text
          timestamp = comments.at_css('span.comment-date span').attr('title')
          updoots = message.at_css('.comment-score span')
          updoots = updoots ? updoots.text.to_i : 0

          embed = Embed.new(title: question.text)
          embed.description = comment
          embed.color = '123123'.to_i(16)
          embed.url = url
          embed.timestamp = DateTime.parse(timestamp).to_time
          embed.author = EmbedAuthor.new(name: user.text, url: "https://stackoverflow.com#{user_link}")
          embed.footer = EmbedFooter.new(text: "#{updoots} #{counters.sample}")

          escaped = event.message.content.match no_inline_regex
          if escaped.nil?
            event.message.delete
            event.respond nil, false, embed
          end
        end
      end
    end
  end
