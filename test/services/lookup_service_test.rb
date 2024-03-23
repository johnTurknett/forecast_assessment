require "test_helper"
require "webmock/minitest"

class LookupServiceTest < ActiveSupport::TestCase
  def setup
    @default_zipcode = "12345"
    Apis::Stubs.set_seed(seed: 1234)
  end

  test "build method returns a Lookup object with correct attributes" do
    lookup = LookupService.build(zipcode: @default_zipcode)

    assert_instance_of Lookup, lookup
    assert_equal @default_zipcode.to_i, lookup.zipcode
  end

  test "build method sets lookup_id if cached lookup exists" do
    cached_lookup = Lookup.create(zipcode: @default_zipcode)
    lookup = LookupService.build(zipcode: @default_zipcode)

    assert_instance_of Lookup, lookup
    assert_equal cached_lookup.id, lookup.lookup_id
  end

  test "build method sets lookup_id to nil if cached lookup does not exist" do
    Lookup.destroy_all
    lookup = LookupService.build(zipcode: @default_zipcode)

    assert_instance_of Lookup, lookup
    assert_nil lookup.lookup_id
  end

  test "find_cached method returns the latest cached lookup for the given zipcode" do
    lookup = Lookup.create(zipcode: @default_zipcode)
    cached_lookup = LookupService.find_cached(zipcode: @default_zipcode)

    assert_instance_of Lookup, lookup
    assert_equal lookup, cached_lookup
  end

  test "find_cached method returns nil if no cached lookup exists for the given zipcode" do
    Lookup.destroy_all
    cached_lookup = LookupService.find_cached(zipcode: @default_zipcode)

    assert_nil cached_lookup
  end

  test "lookup_by_zipcode method returns invalid lookup object when not long enough" do
    lookup = LookupService.lookup_by_zipcode(zipcode: "1234")

    assert_instance_of Lookup, lookup
    assert_equal lookup.valid?, false
    assert_equal ["Zipcode is the wrong length (should be 5 characters)"], lookup.errors.full_messages
  end

  test "lookup_by_zipcode method returns invalid lookup object when not provided" do
    lookup = LookupService.lookup_by_zipcode(zipcode: nil)

    assert_instance_of Lookup, lookup
    assert_equal ["Zipcode is the wrong length (should be 5 characters)"], lookup.errors.full_messages
  end

  test "lookup_by_zipcode method returns cached lookup object" do
    lookup = Lookup.create(zipcode: @default_zipcode)
    cached_lookup = LookupService.lookup_by_zipcode(zipcode: @default_zipcode)

    assert_instance_of Lookup, lookup
    assert_equal lookup.id, cached_lookup.lookup_id
  end

  test "lookup_by_zipcode method retuns new instance with data when data is emmpty" do
    stub_request(:get, "http://localhost:3000/api/v1/national_weather_service/for_zipcode?12345").
      with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Authorization" => "Bearer 0a0a2b29eb0b9047307909551e9e0e62",
        "User-Agent" => "Ruby",
      },
    ).
      to_return(status: 200, body: "", headers: {})

    lookup = LookupService.lookup_by_zipcode(zipcode: @default_zipcode)

    assert_instance_of Lookup, lookup
    assert_equal lookup.data, {}
  end
end
