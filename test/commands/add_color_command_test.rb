require 'simplecov'
SimpleCov.start

require 'test/unit/rr'


class AddColorCommandTest < Test::Unit::TestCase

  def setup
    @event = Object.new
    @server = Object.new
    @user = Object.new

    stub(@user).await! do
      response = Object.new
      message = Object.new
      stub(message).content { "y" }
      stub(response).message { message }
      response
    end
    stub(@user).highest_role

    stub(@server).id { 1 }

    stub(@event).from_bot? { false }
    stub(@event).user { @user }
    stub(@event).server { @server }
    stub(@event).respond { |m| p m }
    stub(@event).bot do
      tmp = Object.new
      stub(tmp).profile do
        tmp2 = Object.new
        stub(tmp2).on { |_| @user }
        tmp2
      end
      tmp
    end
  end

  def teardown
    RoleColor.destroy_all
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::Colors::AddColorCommand.command(@event, "test", "123123")
    assert_nil result
  end

  def test_new_role_color
    stub(@server).roles { [] }
    stub(@server).create_role do
      role = Object.new
      stub(role).name=
      stub(role).colour=
      stub(role).hoist=
      stub(role).mentionable=
      stub(role).reason=
      stub(role).sort_above
      role
    end

    result = Commands::Colors::AddColorCommand.command(@event, 'test', '123123123')
    assert_equal "Color role created", result
  end

  def test_updates_role
    stub(@server).roles do
      Struct.new(:name, )
      role = Object.new
      stub(role).name { 'test' }
      stub(role, "color=")
      [role]
    end

    result = Commands::Colors::AddColorCommand.command(@event, 'test', '123123')
    assert_equal "Color role created", result
  end

  def test_updates_role_color
    RoleColor.create(name: 'test2', server: 1)
    stub(@server).roles do
      Struct.new(:name, )
      role = Object.new
      stub(role).name { 'test' }
      stub(role, "color=")
      [role]
    end
    result = Commands::Colors::AddColorCommand.command(@event, 'test2', '123123')
    assert_equal "Role updated!", result
  end

  def test_it_fails
    result = Commands::Colors::AddColorCommand.command(@event, 'test3', '123123')
    assert_not_nil result
    assert_not_equal "Role updated!", result
    assert_not_equal "Color role created", result
  end
end
