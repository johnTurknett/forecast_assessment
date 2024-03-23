require "application_system_test_case"

class LookupsTest < ApplicationSystemTestCase
  setup do
    @lookup = lookups(:one)
  end

  test "visiting the index" do
    visit lookups_url
    assert_selector "h1", text: "Lookups"
  end

  test "should create lookup" do
    visit lookups_url
    click_on "New lookup"

    fill_in "Zipcode", with: @lookup.zipcode
    click_on "Create Lookup"

    assert_text "Lookup was successfully created"
    click_on "Back"
  end
end
