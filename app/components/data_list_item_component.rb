# frozen_string_literal: true

class DataListItemComponent < ApplicationComponent
  def initialize(data_list_item:, data_list_item_counter:)
    super
    @data_list_item = data_list_item
    @index = data_list_item_counter
  end

  def background
    if @index.even?
      'bg-gray-50'
    else
      'bg-white'
    end
  end
end
