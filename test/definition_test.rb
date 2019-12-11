require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require_relative '../lib/definition'
require_relative '../lib/command_parser/parser'
require 'byebug'

class DefinitionTest < Test::Unit::TestCase

  def test_it_parses_accessors
    result = Definition.parse(
      <<~YAML
        usage: "usage example"
        description: "description example"
        entry: "test.rb" 
        inputs:
          - test     
      YAML
    )
    assert_equal "test", result.name
  end

  def test_it_parses_params
    result = Definition.parse(
      <<~YAML
        usage: "usage example"
        description: "description example"
        entry: "test.rb" 
        inputs:
          test: one  
      YAML
    )
    assert_equal "test:", result.name
  end

  def test_it_tracks_all_definitions
    Definition.parse(
      <<~YAML
        usage: "usage example"
        description: "description example"
        entry: "test.rb" 
        inputs:
          test: one  
      YAML
    )
    Definition.parse(
      <<~YAML
        usage: "usage example"
        description: "description example"
        entry: "test.rb" 
        inputs:
          - test  
      YAML
    )
    assert_equal 2, Definition.all.size
  end
end