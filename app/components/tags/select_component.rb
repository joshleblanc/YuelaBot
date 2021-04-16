class Tags::SelectComponent < ApplicationComponent
  def initialize(object_name, method, choices = nil, options = {}, html_options = {})
    @object_name = object_name
    @method = method
    @choices = choices
    @options = options
    @html_options = html_options

    @html_options[:data] ||= {}
    @html_options[:data].merge!({
      controller: "select"
    })
    @html_options.merge!({
      class: ""
    })
  end

  render do
    helpers.select @object_name, @method, @choices, @options, @html_options
  end
end
