module Helpers
  def escape_md(text)
    # Replace all Discord-flaored markdown special characters, which are not
    # themselves escaped.
    return "" if text.nil?
    text.gsub(/(?<!\\)([`~*_|>])/) { "\\" + $1 }
  end
end