module Commands
  class BibleCommand
    class << self
      include Discordrb::Webhooks

      def name
        :bible
      end

      def attributes
        {
            usage: "bible [book] [chapter:verse(s)].\nExamples: romans 3:2-5\nromans 3:2-5,13:5,12-5",
            description: "Gets bible verse(s) from a given book"
        }
      end

      def command(e, book, *query)
        req = RestClient.get("http://bible-api.com/#{book}+#{query.join}")
        resp = JSON.parse req.body
        embed = Embed.new(
            title: resp["reference"],
            description: resp["text"],
            color: "#FF0000"
        )
        e.respond nil, false, embed
      end
    end
  end
end