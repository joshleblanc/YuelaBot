module Commands
  class LaunchesCommand
    class << self
      include Discordrb::Webhooks

      def name
        :launches
      end

      def attributes
        {
          description: "List upcoming launches",
          usage: "launches",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?

        launches = LaunchManager.instance.launches
        event.channel.send_embed do |embed|
          embed.fields = launches.map { |l| EmbedField.new(name: l["name"], value: l["windowstart"])}
        end
      end
    end
  end
end
