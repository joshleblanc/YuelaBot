class Table::TableHeaderComponent < ApplicationComponent
  render do
    th **@props.to_h, class: class_names("px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider", @props[:class]) do
      content
    end
  end
end
