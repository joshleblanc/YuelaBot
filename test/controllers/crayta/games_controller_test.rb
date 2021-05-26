require "test_helper"

class Crayta::GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get crayta_games_index_url
    assert_response :success
  end

  test "should get show" do
    get crayta_games_show_url
    assert_response :success
  end

  test "should get search" do
    get crayta_games_search_url
    assert_response :success
  end
end
