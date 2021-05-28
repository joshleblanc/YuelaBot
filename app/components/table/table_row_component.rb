class Table::TableRowComponent < ApplicationComponent
  renders_many :cells, Table::TableCellComponent

  render do
    tr do
      cells.map do |cell|
        cell
      end.join.html_safe
    end
  end
end