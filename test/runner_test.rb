require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require_relative '../lib/runner'
require_relative '../lib/definition'
require_relative '../lib/command_parser/parser'
require 'byebug'

class RunnerTest < Test::Unit::TestCase
  def test_a_command_finds_the_definition
    definition = Definition.parse(
      <<~YAML
        usage: "usage example"
        description: "description example"
        entry: "test.rb" 
        inputs:
          - test  
      YAML
    )
    parser = CommandParser::Parser.parse("!!test")
    runner = Runner.run(parser)
    byebug
  end
end