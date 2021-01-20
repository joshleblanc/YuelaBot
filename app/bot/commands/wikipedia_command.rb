module Commands
  class WikipediaCommand
    class << self
      def name
        :wikipedia
      end

      def attributes
        {
          description: "Get an article from wikipedia",
          usage: "wikipedia <term>",
          aliases: [:wiki]
        }
      end

      def command(event, *args)
        return if event.from_bot?
        response = RestClient.get('https://en.wikipedia.org/w/api.php', {
          params: {
            action: 'opensearch',
            search: args.join(' '),
            limit: 1,
            format: 'json'
          }
        })
        body = JSON.parse(response.body)
        link = body[3][0]
        if link
          link
        else
          [
            'No result found',
            'The Wikipedia contains no knowledge of such a thing',
            'The Gods of Wikipedia did not bless us'
          ].sample
        end
      end
    end
  end
end