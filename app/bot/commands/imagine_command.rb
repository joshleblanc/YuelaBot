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
            Generate an image
            #{options_parser.usage}
          USAGE
          aliases: []
        }
      end

      def traits 
        @traits ||= FetchTraitsJob.perform_now("image")
      end

      def styles 
        @styles ||= VeniceClient::ImageApi.new.image_styles_get.data
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:t] = "default"
          options[:s] = "3D Model"

          option_parser.banner = "Usage: imagine [options] query"

          option_parser.on("--list-traits", "List available \"traits\"") do
            options[:lt] = true
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

          option_parser.on("-t", "--trait TRAIT", "Specify a \"trait\"") do |trait|
            options[:t] = trait
          end

          option_parser.on("-r", "--random", "Use a random \"trait\"") do
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
        return if e.from_bot?
        return if e.user.id.to_s == "152107946942136320"

        options, *prompt = args

        if options[:ls]
          output = "```\n"
          output << styles.join("\n") 
          output << "```"
          return output
        end

        if options[:lt]
          output = "```\n"
          output << traits.keys.join("\n") 
          output << "```"
          return output
        end

        if options[:r]
          options[:t] = traits.keys.sample
        end

        if options[:rs]
          options[:s] = styles.sample
        end

        client = VeniceClient::ImageApi.new
        response = client.generate_image(
          generate_image_request: {
            model: traits[options[:t]],
            prompt: prompt.join(" ").strip,
            width: 1024,
            height: 1024,
            format: "png",
            style_preset: options[:s],
            safe_mode: false,
          }
        )
        b64 = response.images.first
        temp_file = Tempfile.new(["imagine", ".png"])
        temp_file.binmode
        temp_file.write(Base64.decode64(b64))
        temp_file.rewind
        e.channel.send_file(temp_file)
        temp_file.unlink
        temp_file.close
      end
    end
  end
end