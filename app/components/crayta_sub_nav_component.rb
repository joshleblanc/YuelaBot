class CraytaSubNavComponent < ApplicationComponent
  def links
    [
      { label: "Games", to: -> { crayta_games_path } },
      { label: "Users", to: -> { crayta_users_path }}
    ]
  end

  render do
    sub_nav do
      sub_nav_component__link_collection links
    end
  end
end