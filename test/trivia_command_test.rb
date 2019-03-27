require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class TriviaCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks
  def setup
    response = Object.new
    stub(response).message do
      message = Object.new
      stub(message).content { 'answer' }
      message
    end

    channel = Object.new
    stub(channel).send_embed do |*_, block|
      embed = Embed.new
      block.call(embed)
      message = Object.new
      stub(message).embeds { [embed] }
      stub(message).edit
    end
    stub(channel).await! { response }
    @event = Object.new
    stub(@event).from_bot? { false }
    stub(@event).channel { channel }
    @trivia_command = Commands::TriviaCommand.new(@event)
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::TriviaCommand.command(@event)
    assert_nil result
  end

  def test_it_gets_question
    result = Commands::TriviaCommand.command(@event)

  end
end