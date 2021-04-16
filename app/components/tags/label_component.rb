class Tags::LabelComponent < ApplicationComponent
  def initialize(object_name, method, text = nil, options = {})
    @object_name = object_name
    @method = method
    @options = options
    @options[:class] = options[:class] || "block text-sm font-medium text-gray-700"
    @text = text
  end

  render do
    helpers.label @object_name, @method, @text, @options
  end
end
