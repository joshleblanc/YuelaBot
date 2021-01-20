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

      def command(event, book, *query)
        return if event.from_bot?
        begin
          resp = RestClient.get("http://bible-api.com/#{book}+#{query.join}")
          data = JSON.parse(resp)
          embed = Embed.new(
              title: data["reference"],
              description: data["text"],
              color: "#FF0000"
          )
          event.respond nil, false, embed
        rescue StandardError => e
          event.respond "We couldn't find anything for book #{book}+#{query.join}"
        end
      end
    end
  end
end