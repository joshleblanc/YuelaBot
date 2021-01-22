require 'simplecov'
SimpleCov.start

require 'test/unit/rr'

class GithubTest < Test::Unit::TestCase
    def setup
        @event = Object.new
        stub(@event).from_bot? { false }
    end

    def test_it_ignores_bot
        stub(@event).from_bot? { true }
        result = Commands::GithubCommand.command(@event)

        assert_nil result
    end

    def test_it_works
        result = Commands::GithubCommand.command(@event)
        assert_equal "https://github.com/HorizonShadow/YuelaBot", result
    end
end