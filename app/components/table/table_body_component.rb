class Table::TableBodyComponent < ApplicationComponent
  render do
    tbody class: "bg-white divide-y divide-gray-200" do
      content
    end
  end
end
