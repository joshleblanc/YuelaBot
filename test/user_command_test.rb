require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class UserCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks

  def setup
    @event = Object.new
    stub(@event).from_bot? { false }

    @command = UserCommand.create(name: 'test', input: 'test', output: 'abc', creator: 'test')
  end

  def teardown
    @command.destroy
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = @command.run(@event, 'test')
    assert_nil result
  end

  def test_it_skips_bad_arg
    result = @command.run(@event, 'abc')
    assert_nil result
  end

  def test_it_responds_to_strings
    result = @command.run(@event, 'test')
    assert_equal result, 'abc'
  end
end
