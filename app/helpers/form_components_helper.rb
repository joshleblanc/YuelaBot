module FormComponentsHelper
  def styled_label_for(object_name, method, text = nil, options = {})
    options[:class] ||= "block text-sm font-medium text-gray-700"
    label object_name, method, text, options
  end
  
  def styled_text_field(object_name, method, options = {})
    options[:class] ||= "disabled:opacity-50 focus:ring-indigo-500 focus:border-indigo-500 flex-1 block w-full rounded-md sm:text-sm border-gray-300"
    text_field object_name, method, options
  end
  
  def styled_select(object_name, method, choices = nil, options = {}, html_options = {})
    html_options[:class] ||= "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    select object_name, method, choices, options, html_options
  end
end
