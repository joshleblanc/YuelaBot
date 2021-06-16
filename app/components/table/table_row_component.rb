class Table::TableRowComponent < ApplicationComponent
  renders_many :cells, Table::TableCellComponent

  render do
    tr do
      cells
    end
  end
end
