# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  def initialize(**args)
    super
    @args = args
  end
end
