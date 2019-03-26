require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require 'fourchan/kit'
require_relative '../commands/4chan_command'

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


    stub(Fourchan::Kit::API).get_boards do
      JSON.parse(open("./test/support/fixtures/4chan/boards.json").read)['boards']
    end

    stub(Fourchan::Kit::API).get_catalog do |_|
      JSON.parse(open("./test/support/fixtures/4chan/wg_catalog.json").read)
    end

    stub(Fourchan::Kit::API).get_thread do |_, _|
      JSON.parse(open("./test/support/fixtures/4chan/wg_thread.json").read)['posts']
    end

    stub(Fourchan::Kit::API).get_threads do |_|
      JSON.parse(open('./test/support/fixtures/4chan/ws_threads.json').read)
    end

    stub(Fourchan::Kit::API).get_page  do |_, _|
      JSON.parse(open("./test/support/fixtures/4chan/wg_first_page.json").read)['threads']
    end

    @board = Fourchan::Kit::Board.new "wg"
    posts = @board.posts
    any_instance_of(Fourchan::Kit::Board) do |klass|
      stub(klass).posts do
        [posts[6]]
      end
    end
  end

  def test_parse_response
    text, quotes = Commands::Random4ChanCommand.parse_response(@board.posts[0].com)
    expected_text = open("./test/support/fixtures/4chan/parsed_post.json").read
    assert quotes.length == 7, "Expected 7 quotes, found #{quotes.length}"
    assert text == expected_text, "Expected: #{expected_text}\ngot: #{text}"
  end

  def test_it_gets_a_random_post
    result = Commands::Random4ChanCommand.command(@event, "wg")
    text, _ = Commands::Random4ChanCommand.parse_response(@board.posts.first.com)
    assert result.description == text
  end
end