require "test_helper"

class Webhooks::TwitchControllerTest < ActionDispatch::IntegrationTest
f  test "it renders ok" do
    post webhooks_twitch_url(server: "123", twitch_user_id: "123"), params: { data: { id: "123" } }
    assert "Ok", response.body
  end
end
