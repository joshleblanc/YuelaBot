class Table::TableHeadComponent < ApplicationComponent
  def initialize(**args)
    @args = args
  end

  render do
    thead class: "bg-gray-50", **@args do
      content
    end
  end
end
