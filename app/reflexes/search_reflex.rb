class SearchReflex < ApplicationReflex
  def search
    cable_ready.push_state(url: "?q=#{params[:q]}")
  end
end