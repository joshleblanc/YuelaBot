require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class PornhubCommandTest < Test::Unit::TestCase
  def setup
    @event = Object.new
    stub(@event).from_bot? { false }
    stub(@event).channel do
      channel = Object.new
      stub(channel).nsfw? { false }
      channel
    end
  end

  def test_nsfw_channel
    event = Object.new
    stub(event).from_bot? { false }
    stub(event).channel do
      channel = Object.new
      stub(channel).nsfw? { true }
      channel
    end
    result = Commands::PornhubCommand.command(event, "")
    assert_not_nil result
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::PornhubCommand.command(@event, "")
    assert_nil result
  end

  def test_it_finds_something
    result = Commands::PornhubCommand.command(@event, "")
    assert_equal "This command can only be used in a NSFW channel", result
  end
end
