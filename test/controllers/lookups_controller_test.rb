require "test_helper"

class LookupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lookup = lookups(:one)
  end

  test "should get index" do
    get lookups_url
    assert_response :success
  end

  test "should get new" do
    get new_lookup_url
    assert_response :success
  end

  test "should create lookup" do
    assert_difference("Lookup.count") do
      post lookups_url, params: { lookup: { zipcode: @lookup.zipcode } }
    end

    assert_redirected_to lookup_url(Lookup.last)
  end

  test "should show lookup" do
    get lookup_url(@lookup)
    assert_response :success
  end
end
