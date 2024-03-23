require "test_helper"
require "webmock/minitest"

class Apis::NationalWeatherServiceTest < ActiveSupport::TestCase
  def setup
    Apis::Stubs.set_seed(seed: 11232)
  end

  test "for_zipcode method returns valid data when successful" do
    api = Apis::NationalWeatherService.new(api_key: "test")
    zipcode = 12345

    stub_request(:get, "http://localhost:3000/api/v1/national_weather_service/for_zipcode?#{zipcode}").
      with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Authorization" => "Bearer test",
        "User-Agent" => "Ruby",
      },
    ).
      to_return(status: 200, body: Apis::Stubs.request.to_json, headers: {})

    result = api.for_zipcode(zipcode: zipcode)

    assert_equal Apis::Stubs.request.to_json, result.to_json
  end

  test "for_zipcode method catch exception when request fails" do
    api = Apis::NationalWeatherService.new(api_key: "should_fail")
    zipcode = 63333

    stub_request(:get, "http://localhost:3000/api/v1/national_weather_service/for_zipcode?#{zipcode}").
      with(
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Authorization" => "Bearer should_fail",
        "User-Agent" => "Ruby",
      },
    ).
      to_return(status: 500, body: "", headers: {})

    result = api.for_zipcode(zipcode: zipcode)

    assert_equal "", result
  end
end
