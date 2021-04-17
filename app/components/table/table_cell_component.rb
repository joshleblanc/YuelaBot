class Table::TableCellComponent < ApplicationComponent
  render do
    td class: class_names("px-6 py-4 whitespace-nowrap", @props[:class]) do
      content
    end
  end
end
