require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class MagicReactionTest < Test::Unit::TestCase
  def setup
    @event = Object.new
    @message = Object.new
    stub(@event).message { @message }
    stub(@event).respond do |_, _, embed|
      assert_equal embed.title, "Turn to Frog"
    end
    stub(@event).<< { |*args| true }
  end

  def test_it_finds_something
    stub(@message).content { "[[turn to frog]]" }
    Reactions::MagicReaction.command(@event)
  end

  def test_it_handles_failed_request
    stub(@message).content { "[[Turn to frog]]" }
    any_instance_of(MTG::QueryBuilder) do |klass|
      stub(klass).all { raise NoMethodError.new("undefined method `empty?' for nil:NilClass") }
    end
    stub(@event).<< do |msg|
      assert_equal "Query failed for Turn to frog. Please try again later.", msg
    end
    Reactions::MagicReaction.command(@event)
  end
end
