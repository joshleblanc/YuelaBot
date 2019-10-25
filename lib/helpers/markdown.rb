module Helpers
  # very basic HTML to markdown converter
  # only supports <i> <b> <strike>
  def html_to_md(text)
    return nil if text.nil?
    markdowns = {
      '<i>' => '*', '</i>' => '*',
      '<b>' => '**', '</b>' => '**',
      '<strike>' => '~~', '</strike>' => '~~'
    }
    text.gsub(/\<\/?([ib]|strike)\>/, markdowns)
  end
end