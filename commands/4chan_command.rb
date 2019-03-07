module Commands
  class Random4ChanCommand
    class << self
      include Discordrb::Webhooks
      def name
        :'4chan'
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: 'Prints a random post from the selected 4chan board',
            usage: '4chan [board]',
            aliases: [:chan]
        }
      end

      def command(event, id)
        board = Fourchan::Kit::Board.new id
        res = board.posts.sample
        text, quotes = parse_response(res.com)
        event.channel.send_embed do |embed|
          embed.color = '#cc0066'
          embed.author = EmbedAuthor.new(name: res.name)
          embed.image = EmbedImage.new(url: res.image_link) unless res.image_link.nil?
          embed.footer = EmbedFooter.new(text: res.now)
          embed.description = text unless text.strip.empty?
          embed.fields = quotes.map do |q|
            EmbedField.new(**q)
          end
        end
      end

      def parse_response(text)
        return "", [] unless text
        text.gsub!('<br>', "\n")
        text = text.split(/<a href=".*" class="quotelink">&gt;&gt;.*\/a>/).delete_if(&:empty?).first
        quotes = text.scan(/<span class="quote">&gt;.*?<\/span>/) rescue []
        num = quotes.length
        quotes = quotes.flatten.map do |quote|
          text.delete!(quote)
          value = quote.sub(/<span class="quote">&gt;(.*)<\/span>/, Nokogiri::HTML.parse("\\1").text)
          if value.length > 1024
            value = "#{value[0..1020]}..."
          end
          num -= 1
          {name: '>' * (num + 1), value: value}
        end
        value = Nokogiri::HTML.parse(text).text
        if value.length > 2048
          value = "#{value[0..2044]}..."
        end
        [value, quotes]
      end
    end
  end
end