require "test_helper"

class Crayta::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get games" do
    get crayta_users_games_url
    assert_response :success
  end
end
