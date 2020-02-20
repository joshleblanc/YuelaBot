require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require_relative '../bot'

class LaunchManagerTest < Test::Unit::TestCase
  def test_it_sends_embed
    stub(BOT).send_message do |channel_id, content, tts, embed|
      assert_equal "Test", embed.title
    end
    LaunchManager.instance.send(:alert_users, {
        "name" => "Test",
        "vidUrls" => ["123"]
    })
  end
end
