# frozen_string_literal: true

class DataListComponent < ApplicationComponent
  def initialize(header: nil, subtitle: nil, data: [])
    super
    @data = data
    @header = header
    @subtitle = subtitle
  end
end
