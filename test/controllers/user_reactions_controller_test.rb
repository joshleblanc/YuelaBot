require "test_helper"

class UserReactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_reaction = user_reactions(:one)
  end

  test "should get index" do
    get user_reactions_url
    assert_response :success
  end

  test "should get new" do
    get new_user_reaction_url
    assert_response :success
  end

  test "should create user_reaction" do
    assert_difference('UserReaction.count') do
      post user_reactions_url, params: { user_reaction: {  } }
    end

    assert_redirected_to user_reaction_url(UserReaction.last)
  end

  test "should show user_reaction" do
    get user_reaction_url(@user_reaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_reaction_url(@user_reaction)
    assert_response :success
  end

  test "should update user_reaction" do
    patch user_reaction_url(@user_reaction), params: { user_reaction: {  } }
    assert_redirected_to user_reaction_url(@user_reaction)
  end

  test "should destroy user_reaction" do
    assert_difference('UserReaction.count', -1) do
      delete user_reaction_url(@user_reaction)
    end

    assert_redirected_to user_reactions_url
  end
end
