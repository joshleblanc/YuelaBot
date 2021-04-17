require "application_system_test_case"

class UserReactionsTest < ApplicationSystemTestCase
  setup do
    @user_reaction = user_reactions(:one)
  end

  test "visiting the index" do
    visit user_reactions_url
    assert_selector "h1", text: "User Reactions"
  end

  test "creating a User reaction" do
    visit user_reactions_url
    click_on "New User Reaction"

    click_on "Create User reaction"

    assert_text "User reaction was successfully created"
    click_on "Back"
  end

  test "updating a User reaction" do
    visit user_reactions_url
    click_on "Edit", match: :first

    click_on "Update User reaction"

    assert_text "User reaction was successfully updated"
    click_on "Back"
  end

  test "destroying a User reaction" do
    visit user_reactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User reaction was successfully destroyed"
  end
end
