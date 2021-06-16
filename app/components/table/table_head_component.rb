class Table::TableHeadComponent < ApplicationComponent
  renders_many :cells, Table::TableHeaderComponent

  def initialize(**args)
    @args = args
  end

  render do
    thead class: "bg-gray-50", **@args do
      cells
    end
  end
end
