module Commands
  class JSCommand
    class << self
      include Discordrb::Webhooks

      def name
        :js
      end

      def attributes
        {
            description: 'JS Eval',
            usage: 'eval [code]',
            aliases: [:eval, :>]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        code = args.join(' ')
        cxt = MiniRacer::Context.new timeout: 3000

        begin
          cxt.eval code
        rescue StandardError => bang
          bang
        end
      end
    end
  end
end