# frozen_string_literal: true

class AfkButtonComponent < ApplicationComponent
  def toggle
    if current_user.afk?
      current_user.back!
    else
      current_user.afk!
    end
  end

  def text
    if afk?
      "Return from AFK"
    else
      "Go AFK"
    end
  end

  def afk?
    current_user.afk?
  end

  def render?
    current_user
  end

  def tippy_data
    return unless afk?
    {
      controller: "tippy",
      "tippy-content": "You're already AFK"
    }
  end
end
