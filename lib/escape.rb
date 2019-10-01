module Helpers
  def Helpers.escape_md(text)
    # Replace all Discord-flaored markdown special characters, which are not
    # themselves escaped.
    text.gsub(/(?<!\\)([`~*_|>])/) { "\\" + $1 }
  end
end