require 'csv'
require_relative './command'

module CommandParser
  class Parser
    class << self
      def parse(str)
        argument_str = str[2..-1]
        argument_str.gsub!(': ', ':')
        p argument_str
        # https://stackoverflow.com/a/11566264
        commands = argument_str.split(/\s(?=(?:[^"]|"[^"]*")*$)/)
        commands.map do |c|
          args = c.split(':')
          arg_hash = {}
          args.each_slice(2) do |a, b|
            key = a
            key += ":" unless b.nil?
            arg_hash[key] = b
          end
          Command.new(arg_hash)
        end        
      end
    end
  end
end