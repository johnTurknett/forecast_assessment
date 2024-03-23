require "test_helper"

class Api::V1::NationalWeatherServiceControllerTest < ActionDispatch::IntegrationTest
  test "for_zipcode method should return valid weather data" do
    Apis::Stubs.set_seed(seed: 12345)
    expected = Apis::Stubs.request.to_json

    get api_v1_national_weather_service_for_zipcode_url
    assert_response :success
    assert_equal expected, response.body
  end
end
