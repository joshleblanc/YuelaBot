require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
class FourChanCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks

  def setup
    @event = Object.new

    stub(@event).from_bot? { false }

    stub(@event).channel.stub!.send_embed do |*_, block|
      embed = Embed.new
      block.call(embed)
      embed
    end


    stub(Apis::FourChan).boards do
      JSON.parse(open("./test/support/fixtures/4chan/boards.json").read)['boards']
    end

    stub(Apis::FourChan).catalog do |_|
      JSON.parse(open("./test/support/fixtures/4chan/wg_catalog.json").read)
    end

    stub(Apis::FourChan).thread do |_, _|
      JSON.parse(open("./test/support/fixtures/4chan/wg_thread.json").read)
    end

    stub(Apis::FourChan).threads do |_|
      JSON.parse(open('./test/support/fixtures/4chan/wg_threads.json').read)
    end

    stub(Apis::FourChan).get_page  do |_, _|
      JSON.parse(open("./test/support/fixtures/4chan/wg_first_page.json").read)
    end
  end

  def test_parse_response
    text, quotes = Commands::Random4chanCommand.parse_response(Apis::FourChan.thread('1', '1')['posts'].first['com'])
    expected_text = open("./test/support/fixtures/4chan/parsed_post.json").read
    assert quotes.length == 7, "Expected 7 quotes, found #{quotes.length}"
    assert text == expected_text, "Expected: #{expected_text}\ngot: #{text}"
  end

  def test_it_gets_a_random_post
    result = Commands::Random4chanCommand.command(@event, "wg")
    text, _ = Commands::Random4chanCommand.parse_response(Apis::FourChan.thread('1', '1')['posts'].first['com'])
    assert result.description == text
  end
end