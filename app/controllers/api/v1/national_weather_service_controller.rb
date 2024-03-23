class Api::V1::NationalWeatherServiceController < Api::BaseController
  # GET /api/v1/national_weather_service/for_zipcode
  def for_zipcode
    render json: Apis::Stubs.request, status: :ok
  end
end
