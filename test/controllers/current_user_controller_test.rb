require "test_helper"

class CurrentUserControllerTest < ActionDispatch::IntegrationTest
  test "should get toggle_afk" do
    get current_user_toggle_afk_url
    assert_response :success
  end
end
