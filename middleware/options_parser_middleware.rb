require 'optparse'

module Middleware
  class OptionsParserMiddleware < ApplicationMiddleware
    def initialize(&blk)
      @blk = blk
    end

    def to_s
      parser.to_s
    end

    # this is intentionally not memoized
    def parser(options = {})
      OptionParser.new do |option_parser|
        # OptionParser appears to implicitly run `exit` if `-h` is passed,
        # so we need to override that by default.
        option_parser.on('-h') do
          raise OptionParser::InvalidOption.new
        end
        @blk.call(option_parser, options)
      end
    end

    ###
    # The before and after method stubs are defined in ApplicationMiddleware
    # They can safely be deleted if you're not using that particular method.

    ###
    # Called before running the command. The output will be passed into the command
    # as the arguments
    def before(event, *args)
      options = {}
      parser(options).parse!(args)      
      [options, *args]
    end
  end
end
