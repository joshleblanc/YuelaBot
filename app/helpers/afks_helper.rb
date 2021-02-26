module AfksHelper
  def tippy_data
    return unless current_user.afk?
    {
      controller: "tippy",
      "tippy-content": "You're already AFK"
    }
  end

  def text
    if current_user.afk?
      "Return from AFK"
    else
      "Go AFK"
    end
  end
end
