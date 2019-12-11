require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require_relative '../lib/command_parser/parser'
require_relative '../lib/command_parser/command'
require 'byebug'

class ParserTest < Test::Unit::TestCase

  def test_it_parses_accessors
    result = CommandParser::Parser.parse("!!test")
    assert_equal 1, result.length
    assert_equal "test", result[0].name
  end

  def test_it_parses_params
    result = CommandParser::Parser.parse("!!test: abc")
    assert_equal 1, result.length
    assert_equal "test:", result[0].name
  end

  def test_it_parses_multiple_commands
    result = CommandParser::Parser.parse("!!test: abc ndugger")
    assert_equal 2, result.length
  end

  def test_it_parses_strings
    result = CommandParser::Parser.parse('!!test: "a b c"')
    assert_equal 1, result.length
    assert_equal 1, result[0].args.values.length
  end

  def test_it_parses_multiple_commands_with_string
    result = CommandParser::Parser.parse('!!test: "a b c" ndugger')
    assert_equal 2, result.length
    assert_equal 1, result[0].args.values.length
    assert_equal nil, result[1].args.values[0]
  end
end