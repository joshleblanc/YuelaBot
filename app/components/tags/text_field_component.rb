class Tags::TextFieldComponent < ApplicationComponent
  CLASSNAMES = "disabled:opacity-50 focus:ring-indigo-500 focus:border-indigo-500 flex-1 block w-full rounded-md sm:text-sm border-gray-300"
  def initialize(object_name, method, options = {})
    @object_name = object_name
    @method = method
    @options = options
    @options[:class] ||= TextFieldComponent::CLASSNAMES
    @options[:data] ||= {}
    @options[:data][:reflex] = "change->FormReflex#handle_change"
  end

  render do
    helpers.text_field @object_name, @method, @options
  end
end
