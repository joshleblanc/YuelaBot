require 'simplecov'
SimpleCov.start

require 'test/unit/rr'

class EscapeMarkdownTest < Test::Unit::TestCase
  include Helpers::Escape

  def test_it_escapes_asterisks()
    source = 'hello * world \\* howdy'
    expected = 'hello \\* world \\* howdy'

    assert_equal(expected, escape_md(source))
  end

  def test_it_whatever()
    # Shamelessly stolen from discord.js
    # https://github.com/discordjs/discord.js/blob/651ff81bd522c03b5c9724a3a8c14eeb88dcd6b9/test/escapeMarkdown.test.js#L6
    source = '`_Behold!_`\n||___~~***```js\n`use strict`;\nrequire(\'discord.js\');```***~~___||'
    expected = '\\`\\_Behold!\\_\\`\n\\|\\|\\_\\_\\_\\~\\~\\*\\*\\*\\`\\`\\`js\n\\`use strict\\`;\nrequire(\'discord.js\');\\`\\`\\`\\*\\*\\*\\~\\~\\_\\_\\_\\|\\|'

    assert_equal(expected, escape_md(source))
  end
end