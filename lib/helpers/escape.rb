module Helpers
  def escape_md(text)
    # Replace all Discord-flaored markdown special characters, which are not
    # themselves escaped.
    return nil if text.nil?
    text.gsub(/(?<!\\)([`~*_|>])/) { "\\" + $1 }
  end

  # html isn't regular, so this isn't always going to work
  def escape_xml(text)
    return nil if text.nil?
    text.gsub(/<[^>]*>/, "")
  end
end