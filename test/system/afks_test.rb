require "application_system_test_case"

class AfksTest < ApplicationSystemTestCase
  setup do
    @afk = afks(:one)
  end

  test "visiting the index" do
    visit afks_url
    assert_selector "h1", text: "Afks"
  end

  test "creating a Afk" do
    visit afks_url
    click_on "New Afk"

    click_on "Create Afk"

    assert_text "Afk was successfully created"
    click_on "Back"
  end

  test "updating a Afk" do
    visit afks_url
    click_on "Edit", match: :first

    click_on "Update Afk"

    assert_text "Afk was successfully updated"
    click_on "Back"
  end

  test "destroying a Afk" do
    visit afks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Afk was successfully destroyed"
  end
end
