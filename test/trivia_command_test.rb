require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

Message = Struct.new(:embeds) do
  def edit(_, _)
    self
  end
end

class TriviaCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks
  def setup
    message = Object.new
    user = Object.new
    @response = Object.new

    stub(message).content { 'Medici With A Space' }
    stub(user).id { 1 }
    stub(user).name { 'test' }
    stub(user).score { 0 }
    stub(@response).message { message }
    stub(@response).user { user }

    @channel = Object.new
    stub(@channel).send_embed do |*_, block|
      embed = Embed.new
      block.call(embed)

      message_struct = Message.new
      message_struct.embeds = [embed]
      message_struct
    end
    stub(@channel).await! { @response }
    @event = Object.new
    stub(@event).from_bot? { false }
    stub(@event).channel { @channel }
    stub(RestClient).get("jservice.io/api/random") do
      stub!.body do
        open("./test/support/fixtures/trivia/trivia.json").read
      end
    end

    any_instance_of(Commands::TriviaCommand) do |klass|
        stub(klass).sleep { sleep 0.1 }
    end
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::TriviaCommand.command(@event)
    assert_nil result
  end

  def test_it_gets_question
    step = 0
    count = 0
    stub(@channel).send_embed do |*_, block|
      embed = Embed.new
      block.call(embed)

      message_struct = Message.new
      message_struct.embeds = [embed]
      message_struct

      if count == 10
        assert_nil embed.description
        assert_equal "**<@1>** got 10 points\n", embed.fields[0].value
      else
        case step
        when 0
          assert_equal "You can stop trivia with !!stop", embed.description,
          step = 1
        when 1
          assert_equal "<@1> got it! The answer was: **Medici With A Space**", embed.description
          step = 0
          count += 1
        end
      end
    end
    Commands::TriviaCommand.command(@event)
  end

  def test_no_players
    count = 0
    message = Object.new
    user = Object.new
    response = Object.new

    stub(message).content { '!!stop' }
    stub(user).id { 1 }
    stub(user).name { 'test' }
    stub(user).score { 0 }
    stub(response).message { message }
    stub(response).user { user }
    stub(@channel).send_embed do |*_, block|
      embed = Embed.new
      block.call(embed)
      case count
      when 0
        assert_equal "You can stop trivia with !!stop", embed.description
        count = 1
      when 1
        assert_equal "Okay, stopping after this question", embed.description
        count = 2
      when 2
        assert_equal "Time's up! The answer was: **Medici With A Space**", embed.description
        count = 3
      when 3
        assert_equal "No one played!", embed.fields[0].value
      end
      message_struct = Message.new
      message_struct.embeds = [embed]
      message_struct
    end
    stub(@channel).await! { response }
    Commands::TriviaCommand.command(@event)
  end

  def test_bad_question
    request_count = 0
    stub(RestClient).get("jservice.io/api/random") do
      stub!.body do
        if request_count == 0
          request_count = 1
          open("./test/support/fixtures/trivia/bad_trivia.json").read
        else
          open("./test/support/fixtures/trivia/trivia.json").read
        end
      end
    end
    Commands::TriviaCommand.command(@event)
    assert_equal 1, request_count
  end

  def test_slow_answer
    step = 0
    edits = 0
    any_instance_of(Commands::TriviaCommand) do |klass|
        stub(klass).done? { true }
    end
    stub(@channel).await! do
      if step == 0
        sleep 1
        step = 1
      end
      @response
    end
    stub(@channel).send_embed do |*_, block|
      embed = Embed.new
      block.call(embed)
      message_struct = Message.new
      message_struct.embeds = [embed]
      stub(message_struct).edit do |_, new_embed|
        assert_not_nil new_embed.footer # a hint was edited in
        edits += 1
        message_struct
      end
      message_struct
    end
    Commands::TriviaCommand.command(@event)
    assert_equal 3, edits
  end
end