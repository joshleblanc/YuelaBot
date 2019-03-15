require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require_relative '../bot'

class UrbanCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks

  def setup
    @event = Object.new
    stub(@event).from_bot? { false }
    stub(@event).respond { |_, _, c| c }
    stub(@event).<< { |c| c }

    urban_response = RestClient.get('http://api.urbandictionary.com/v0/define', params: {term: 'test'})
    @urban = JSON.parse(urban_response)['list']
  end

  def test_single_argument
    definition = @urban.first
    result = Commands::UrbanCommand.command(@event, "test")

    assert(definition['definition'].eql?(result.description), "expected #{definition['definition']} but was #{result.description}")
  end

  def test_with_index
    definition = @urban[1]

    result = Commands::UrbanCommand.command(@event, "test", 1)
    assert(definition['definition'].eql?(result.description), "expected #{definition['definition']} but was #{result.description}")
  end

  def test_with_out_of_bounds_index
    result = Commands::UrbanCommand.command(@event, "test", 99999)
    assert(result.eql? "I couldn't find anything for that")
  end

  def test_negative_index
    definition = @urban.first

    result = Commands::UrbanCommand.command(@event, "test", -1)
    assert(result.description.eql?(definition['definition']), "expected #{definition['definition']}, but was #{result.description}")
  end
end