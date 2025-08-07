class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &blk)
    options[:class] ||= "block text-sm font-medium text-gray-700"
    super
  end

  def text_field(method, options = {})
    options[:class] ||= "disabled:opacity-50 focus:ring-indigo-500 focus:border-indigo-500 flex-1 block w-full rounded-md sm:text-sm border-gray-300"
    super
  end

  def container_for(method, **options, &block)
    options[:class] = [options[:class], "mb-2"].compact.join(" ")
    @template.content_tag(:div, options) do
      @template.capture(&block)
    end
  end

  def error_for(attribute, **options)
    return "".html_safe unless @object && @object.errors[attribute].present?
    options[:class] = [options[:class], "text-xs text-red-500 font-medium"].compact.join(" ")
    @template.content_tag(:p, @object.errors.full_messages_for(attribute).join(", "), options)
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    html_options[:class] ||= "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    super
  end
end
