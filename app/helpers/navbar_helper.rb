module NavbarHelper
  def navbar_links
    links = [
      { label: "Home", path: root_path }
    ]
    
    if current_user
      links.push(
        { label: "Game Keys", path: game_keys_path },
        { label: "Reactions", path: user_reactions_path }
      )
    end
    
    links
  end
end
