module Commands 
  class ImagineCommand
    class << self
      MODELS = ["venice-sd35", "fluently-xl", "flux-dev", "flux-dev-uncensored", "lustify-sdxl", "pony-realism"]
      def name
        :imagine
      end

      def attributes
        {
          description: <<~USAGE,
            cowsay, need I say more?
            #{options_parser.usage}
          USAGE
          aliases: []
        }
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:m] = "venice-sd35"

          option_parser.banner = "Usage: imagine [options] query"

          option_parser.on("-l", "--list", "List available \"models\"") do
            options[:l] = true
          end

          option_parser.on("-m", "--model MODEL", "Specify a \"model\"") do |model|
            options[:m] = model
          end

          option_parser.on("-r", "--random", "Use a random  \"model\"") do
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

        options, *prompt = args

        p options, prompt

        if options[:l]
          output = "```\n"
          output << MODELS.join("\n") 
          output << "```"
          return output
        end

        if options[:r]
          options[:m] = MODELS.sample
        end

        client = OpenAI::Client.new
        response = client.images.generate(
          parameters: {
            model: options[:m],
            prompt: prompt.join(" ").strip,
            size: "1024x1024",
            quality: "auto",
            moderation: "low"
          }
        )
        b64 = response.dig("data", 0, "b64_json")
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