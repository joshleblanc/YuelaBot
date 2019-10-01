require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class PollCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks
  def setup
    @event = Object.new
    stub(@event).from_bot? { false }
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::PollCommand.command(@event)
    assert_nil result
  end

  def fake_poll(provide_answer = false)
    outer_step = 0
    message = stub! do
      content do
        case outer_step
        when 1
          "test?"
        when 2
          "test"
        when 3
          "!!done"
        end
      end
    end
    response = stub! do
      message { message }
    end
    response.server { nil }
    user = stub! do
      id { 1 }
      pm
      await! do
        outer_step += 1
        response
      end
    end

    inner_step = 0

    answer_message = Object.new
    stub(answer_message).content { "a" }

    answer = Object.new
    stub(answer).user { user }
    stub(answer).message { answer_message }

    any_instance_of(Commands::PollCommand) do |klass|
        stub(klass).sleep { sleep 0.5 }
    end

    channel = stub! do
      send_embed do |_, block|
        embed = Embed.new
        block.call(embed)
        embed
      end

      await! do
        case inner_step
        when 0
          inner_step = 1
          if provide_answer
            answer
          else
            sleep 1
          end
        when 1
          sleep 1
        end
      end
    end

    stub(@event).user { user }
    stub(@event).channel { channel }
    Commands::PollCommand.command(@event)
  end

  def test_no_votes
    result = fake_poll(false)
    assert_equal "A) test **0.0%**", result.fields[0].value
  end

  def test_success
    result = fake_poll(true)
    assert_equal "A) test **100.0%**", result.fields[0].value
  end
end