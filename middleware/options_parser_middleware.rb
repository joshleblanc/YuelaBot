require 'optparse'

module Middleware
  class OptionsParserMiddleware < ApplicationMiddleware
    def initialize(&blk)
      @blk = blk
    end

    ###
    # The before and after method stubs are defined in ApplicationMiddleware
    # They can safely be deleted if you're not using that particular method.

    ###
    # Called before running the command. The output will be passed into the command
    # as the arguments
    def before(event, *args)
      options = {}
      parser = OptionParser.new do |option_parser|
        @blk.call(option_parser, options)
      end
      parser.parse!(args)
      
      [options, *args]
    end

    ###
    # Called after running the command. The output will be used as the output of the command.
    # Note: If the command uses event.respond or any other methods of writing to discord, this value will
    # not be intercepted.
    def after(event, output, *args)
      output
    end
  end
end
