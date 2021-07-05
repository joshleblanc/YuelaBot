class TextFieldComponent < ApplicationComponent
  CLASSNAMES = "disabled:opacity-50 focus:ring-indigo-500 focus:border-indigo-500 flex-1 block w-full rounded-md sm:text-sm border-gray-300"

  def initialize(method, opts = {})
    @method = method
    @opts = opts
  end

  render do
    helpers.text_field nil, @method, class: CLASSNAMES, **@opts
  end
end