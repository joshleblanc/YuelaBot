require 'simplecov'
SimpleCov.start

require 'test/unit/rr'

class AfkTest < Test::Unit::TestCase
  def setup
    author = Object.new
    stub(author).name { 'test'}
    stub(author).id { 1 }

    user = Object.new
    stub(user).await do |id, blk|
      @await_block = blk
    end

    @event = Object.new
    stub(@event).from_bot? { false }
    stub(@event).author { author }
    stub(@event).user { user }
  end

  def teardown
    User.destroy_all
    Afk.destroy_all
  end

  def test_it_registers_an_afk
    result = Commands::AfkCommand.command(@event, "test")
    afk = Afk.first

    assert_nil result
    assert_not_nil afk
    assert_not_nil afk.user
    assert_equal afk.message, 'test'
    assert_equal afk.user.name, 'test'
  end

  def test_it_removes_afk
    Commands::AfkCommand.command(@event, "test")
    result = @await_block.call(@event)

    assert_not_nil result
    assert_equal result.message, "test"
  end

  def test_it_fails
    stub(@event).author { nil }
    result = Commands::AfkCommand.command(@event, "test")
    assert_not_nil result
  end
end