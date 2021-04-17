class Table::TableComponent < ApplicationComponent
  render do
    table class: "min-w-full divide-y divide-gray-200 table-fixed w-full" do
      content
    end
  end
end
