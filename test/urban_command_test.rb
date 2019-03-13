require 'test/unit/rr'
require_relative '../bot'

class UrbanCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks

  def test_single_argument
    event = Object.new
    stub(event).from_bot? { false }
    stub(event).respond { |_, _, c| c }

    urban_response = RestClient.get('http://api.urbandictionary.com/v0/define', params: {term: 'test'})
    definition = JSON.parse(urban_response)['list'].first

    result = Commands::UrbanCommand.command(event, "test")

    assert(definition['definition'].eql?(result.description), "expected #{definition['definition']} but was #{result.description}")
  end
end