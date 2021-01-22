require 'simplecov'
SimpleCov.start

require 'test/unit/rr'


class BibeCommandTest < Test::Unit::TestCase
  def setup
    @event = Object.new
    stub(@event).from_bot? { false }
    stub(RestClient).get do |_, _|
      File.read("./test/support/fixtures/bible/john_316.json")
    end
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::BibleCommand.command(@event, "")
    assert_nil result
  end

  def test_it_finds_something
    stub(@event).respond do |_, _, embed|
      assert_equal "John 3:16", embed.title
      assert_equal "\nFor God so loved the world, that he gave his one and only Son, that whoever believes in him should not perish, but have eternal life.\n\n", embed.description
      assert_equal 16711680, embed.colour
    end

    Commands::BibleCommand.command(@event, "john", "3:16")
  end

  def test_it_informs_of_error
    stub(@event).respond do |message|
      assert_equal "We couldn't find anything for book error+z", message
    end

    Commands::BibleCommand.command(@event, "error", "z")
  end
end
