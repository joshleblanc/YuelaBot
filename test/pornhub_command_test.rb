require 'simplecov'
SimpleCov.start

require 'test/unit/rr'
require 'discordrb'
require_relative '../bot'

class ArchiveTest < Test::Unit::TestCase  
  def setup
  end

  def test_it_ignores_bot
    stub(@event).from_bot? { true }
    result = Commands::ArchiveConfigCommand.command(@event, "<#1>")
    assert_nil result
  end

  def test_it_creates_an_archive
    result = Commands::ArchiveConfigCommand.command(@event, "<#1>")
    assert_equal result, "Archive configured"
  end

  def test_it_archives_a_message
    embeds = Object.new
    stub(embeds).empty? { true }

    stub(@pin).embeds { embeds }
    result = Routines.archive_routine(@event)

    assert_equal result.description, "Test"
    assert_equal result.author.name, "test"
    assert_equal result.author.icon_url, "test"
    assert_equal result.footer.text, "Test"
    assert_equal result.timestamp, "0000-00-00"
  end

  def test_it_archives_an_embed
    embed = Embed.new(
        timestamp: "0000-00-00",
        description: "test",
        author: EmbedAuthor.new(
            name: "test",
            url: "test",
            icon_url: "test"
        ),
        color: "#000000",
        fields: [
            EmbedField.new(
                name: "test",
                inline: false,
                value: "test"
            )
        ],
        footer: EmbedFooter.new(
            text: "test",
            icon_url: "test"
        ),
        image: EmbedImage.new(
            url: "test"
        ),
        thumbnail: EmbedThumbnail.new(
            url: "test"
        ),
        title: "test",
        url: "test"
    )
    stub(@pin).embeds { [embed] }
    result = Routines.archive_routine(@event)


    assert_equal(result.description, "test")
  end
end
