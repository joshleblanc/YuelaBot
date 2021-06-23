# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  CLASSNAMES = "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
  
  render do
    button_tag class: CLASSNAMES, **@props do
      content
    end
  end
end
