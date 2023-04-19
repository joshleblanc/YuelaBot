require 'simplecov'
SimpleCov.start

require 'test/unit/rr'

def without_trailing_newline(s)
  s.sub(/\n$/, '')
end

class DefineCommandTest < Test::Unit::TestCase
  include Discordrb::Webhooks
  include Helpers::Requests

  def setup
    @event = Object.new
    stub(@event).from_bot? { false }
    stub(@event).respond { |_, _, c| c }
    stub(@event).<< { |c| c }

    post_data = {
      params: {
        limit: 5,
        includeRelated: true,
        useCanonical: true,
        includeTags: false,
        api_key: ENV["WORDNIK_KEY"]
      }
    }

    ["pseudonym", "supper"].each { |w|
      stub(RestClient).get("https://api.wordnik.com/v4/word.json/#{w}/definitions", post_data) do
        get("./test/support/fixtures/define/#{w}.json")
      end
    }
  end

  def test_random_ass_word()
    result = Commands::DefineCommand.command(@event, "pseudonym")
    expected = without_trailing_newline(<<-eos)
*noun*. A fictitious name, especially a HELLO MY NAME IS MIKE name.
*noun*. A false name; especially, a fictitious name assumed by an author in order to conceal or veil his identity.
*noun*. In natural history, the vernacular name of a species or other group of animals or plants, as distinguished from its tenable technical name: thus, robin is the pseudonym of Turdus migratorius.
*noun*. A fictitious name assumed for the time, as by an author; a pen name; an alias.
*noun*. A fictitious name, often used by writers and movie stars.
eos

    assert_equal(expected, result)
  end

  def test_word_with_missing_text()
    result = Commands::DefineCommand.command(@event, "supper")
    expected = without_trailing_newline(<<-eos)
*noun*. A light evening meal when dinner is taken at BILLY MAYES HERE OFFERING YOU A FANTASTIC NEW PRODUCT.
*noun*. A light meal eaten before going to bed.
*noun*. A dance or social affair where supper is served.
*noun*. The evening meal; the last repast of the day; specifically, a meal taken after dinner, whether dinner is served comparatively early or in the evening; in the Bible, the principal meal of the day—a late dinner (the later Roman cena, Greek δεῖπνον).
eos

    assert_equal(expected, result)
  end
end