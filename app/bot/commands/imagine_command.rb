require 'optparse/shellwords'

module Commands
  class ImagineCommand
    class << self
      def name
        :imagine
      end

      def attributes
        {
          description: <<~USAGE,
            Generate an image (uses default model unless specified)
            #{options_parser.usage}
          USAGE
          aliases: []
        }
      end

      def traits
        @traits ||= FetchTraitsJob.perform_now("image")
      end

      def models
        @models ||= VeniceClient::ModelsApi.new.list_models(type: "image").data.map(&:id)
      end

      def styles
        @styles ||= VeniceClient::ImageApi.new.image_styles_get.data
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          #options[:s] = "3D Model"
          options[:m] = "grok-imagine"

          option_parser.banner = "Usage: imagine [options] query"

          option_parser.on("--list-models", "List available \"models\"") do
            options[:lm] = true
          end

          option_parser.on("-rs", "--random-style", "Use a random \"style\"") do
            options[:rs] = true
          end

          option_parser.on("-s", "--style STYLE", "Specify a \"style\"") do |style|
            options[:s] = style
          end

          option_parser.on("--list-styles", "List available \"styles\"") do
            options[:ls] = true
          end

          option_parser.on("-m", "--model MODEL", "Specify a \"model\"") do |model|
            options[:m] = model
          end

          option_parser.on("-r", "--random", "Use a random \"model\"") do
            options[:r] = true
          end
        end
      end

      def middleware
        [
          options_parser
        ]
      end

      def command(e, *args)
        return if e.respond_to?(:from_bot?) && e.from_bot?

        author = e.respond_to?(:user) ? e.user : e.author
        return if author.id.to_s == "152107946942136320"

        options, *prompt = args

        if options[:ls]
          output = "```\n"
          output << styles.join("\n")
          output << "```"
          return output
        end

        if options[:lm]
          output = "```\n"
          output << models.join("\n")
          output << "```"
          return output
        end

        if options[:r]
          options[:m] = models.sample
        end

        if options[:rs]
          options[:s] = styles.sample
        end

        client = VeniceClient::ImageApi.new
        body = {
            model: options[:m],
            prompt: prompt.join(" ").strip,
            width: 1024,
            height: 1024,
            format: "png",
            safe_mode: false,
        }

        body[:style_preset] = options[:s] if options[:s]
        response = client.generate_image(
          generate_image_request: body
        )
        b64 = response.images.first
        temp_file = Tempfile.new(["imagine", ".png"])
        temp_file.binmode
        temp_file.write(Base64.decode64(b64))
        temp_file.rewind
        if e.respond_to?(:interaction)
          e.edit_response(content: "", attachments: [temp_file])
        else
          e.channel.send_file(temp_file)
        end
        temp_file.unlink
        temp_file.close
      end
    end
  end
end
