require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require_relative '../bot'

class UrbanCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks

  def setup
    @event = Object.new

    user = Object.new
    stub(user).avatar_url
    stub(user).name
    stub(user).id

    message = Object.new
    stub(message).create_reaction
    stub(message).delete_all_reactions

    any_instance_of(Discordrb::Commands::CommandBot) do |klass|
      stub(klass).add_await! do
        sleep 1
        nil
      end
    end

    stub(@event).from_bot? { false }
    stub(@event).respond { |_, _, c| c }
    stub(@event).<< { |c| c }
    stub(@event).user { user }
    stub(@event).respond do |*_, embed|
      assert_equal @urban[0]['definition'], embed.description
      message
    end

    stub(RestClient).get do |_, _|
      File.read("./test/support/fixtures/urban/urban.json")
    end

    urban_response = RestClient.get('http://api.urbandictionary.com/v0/define', params: {term: 'test'})
    @urban = JSON.parse(urban_response)['list']
  end

  def test_single_argument
    definition = @urban.first
    assert_nothing_raised do
      Commands::UrbanCommand.command(@event, "test")
    end
  end
end