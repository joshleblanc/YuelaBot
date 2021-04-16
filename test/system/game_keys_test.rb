require "application_system_test_case"

class GameKeysTest < ApplicationSystemTestCase
  setup do
    @game_key = game_keys(:one)
  end

  test "visiting the index" do
    visit game_keys_url
    assert_selector "h1", text: "Game Keys"
  end

  test "creating a Game key" do
    visit game_keys_url
    click_on "New Game Key"

    click_on "Create Game key"

    assert_text "Game key was successfully created"
    click_on "Back"
  end

  test "updating a Game key" do
    visit game_keys_url
    click_on "Edit", match: :first

    click_on "Update Game key"

    assert_text "Game key was successfully updated"
    click_on "Back"
  end

  test "destroying a Game key" do
    visit game_keys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Game key was successfully destroyed"
  end
end
