module AfkHelper
  def afk_button_text(user)
    user.afk? ? "Return from AFK" : "Go AFK"
  end
  
  def afk_tippy_data(user)
    return unless user.afk?
    {
      controller: "tippy",
      "tippy-content": "You're already AFK"
    }
  end
end
