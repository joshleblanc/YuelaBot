require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class PornhubCommandTest < Test::Unit::TestCase
  def setup
    @event = Object.new
    stub(@event).from_bot? { false }
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::PornhubCommand.command(@event, "")
    assert_nil result
  end

  def test_it_finds_something
    result = Commands::PornhubCommand.command(@event, "")
    assert_not_nil result
  end
end
