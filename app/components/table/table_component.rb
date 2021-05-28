class Table::TableComponent < ApplicationComponent
  renders_many :table_rows, Table::TableRowComponent
  renders_many :table_headers, Table::TableHeadComponent

  render do
    table class: "min-w-full divide-y divide-gray-200 table-fixed w-full" do
      text_node(table_headers.map do |th|
        th
      end.join.html_safe)
      table__table_body do
        table_rows.map do |row|
          row
        end.join
      end
    end
  end
end
