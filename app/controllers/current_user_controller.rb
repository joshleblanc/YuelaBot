class CurrentUserController < ApplicationController
  def toggle_afk
    if current_user.afk?
      current_user.back!
    else
      current_user.afk!
    end
  end
end
