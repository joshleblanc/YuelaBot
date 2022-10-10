class GameKeyReflex < ApplicationReflex
  before_reflex do
    p element.signed[:game_key]
    @game_key = element.signed[:game_key]
  end

  def claim
    @game_key.claim!
    morph(
      dom_id(@game_key),
      render(partial: "game_keys/game_key_row", locals: { game_key: @game_key, key_visible: true })
    )
  end
end
