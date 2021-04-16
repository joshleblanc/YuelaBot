require "test_helper"

class GameKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_key = game_keys(:one)
  end

  test "should get index" do
    get game_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_game_key_url
    assert_response :success
  end

  test "should create game_key" do
    assert_difference('GameKey.count') do
      post game_keys_url, params: { game_key: {  } }
    end

    assert_redirected_to game_key_url(GameKey.last)
  end

  test "should show game_key" do
    get game_key_url(@game_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_game_key_url(@game_key)
    assert_response :success
  end

  test "should update game_key" do
    patch game_key_url(@game_key), params: { game_key: {  } }
    assert_redirected_to game_key_url(@game_key)
  end

  test "should destroy game_key" do
    assert_difference('GameKey.count', -1) do
      delete game_key_url(@game_key)
    end

    assert_redirected_to game_keys_url
  end
end
