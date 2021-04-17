class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &blk)
    @template.render Tags::LabelComponent.new(@object_name, method, text, objectify_options(options)), &blk
  end

  def text_field(method, options = {})
    @template.render Tags::TextFieldComponent.new(@object_name, method, objectify_options(options))
  end

  def container_for(method, **options, &block)
    options.merge!({ class: "mb-2" })
    super
  end

  def error_for(attribute, **options)
    options.merge!({
      class: "text-xs text-red-500 font-medium"
    })
    super
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    @template.render Tags::SelectComponent.new(@object_name, method, choices, objectify_options(options), @default_html_options.merge(html_options), &block)
  end
end
