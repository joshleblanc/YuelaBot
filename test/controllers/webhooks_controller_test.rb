require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "should get twitch" do
    get webhooks_twitch_url
    assert_response :success
  end
end
