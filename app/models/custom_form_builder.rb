class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &blk)
    options[:class] ||= "block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
    super
  end

  def text_field(method, options = {})
    options[:class] ||= "disabled:opacity-50 focus:ring-primary-500 focus:border-primary-500 flex-1 block w-full rounded-lg sm:text-sm border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 px-3 py-2 transition-colors"
    super
  end

  def container_for(method, **options, &block)
    options[:class] = [options[:class], "mb-5"].compact.join(" ")
    @template.content_tag(:div, options) do
      @template.capture(&block)
    end
  end

  def error_for(attribute, **options)
    return "".html_safe unless @object && @object.errors[attribute].present?
    options[:class] = [options[:class], "text-xs text-red-500 dark:text-red-400 font-medium mt-1.5 flex items-center gap-1"].compact.join(" ")
    @template.content_tag(:p, "⚠️ " + @object.errors.full_messages_for(attribute).join(", "), options)
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    html_options[:class] ||= "mt-1 block w-full py-2 px-3 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 dark:text-white rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
    super
  end
end
