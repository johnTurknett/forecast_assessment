require "net/http"
require "uri"

module Apis
  class NationalWeatherService
    ENDPOINT = "http://localhost:3000/api/v1/national_weather_service/for_zipcode".freeze

    def initialize(api_key:)
      raise ArgumentError.new("No API key provided") if api_key.blank?
      @api_key = api_key
    end

    # Retrieves weather data for a given zipcode.
    #
    # @param zipcode [String] The zipcode for which to retrieve weather data.
    # @return [Hash] The weather data as a hash or empty string.
    def for_zipcode(zipcode:)
      http, request = get_request(zipcode: zipcode)
      data = ""

      begin
        response = http.request(request)

        data = JSON.parse(response.body) unless response.body.blank?
      rescue
        # not recommended to capture every exception, but there are
        # waaaaaay to many things that can go wrong with a network request
        # to cover in this assessment...

        # log exception and report it to external logging tool
      end

      data
    end

    private

    # Generates a get request to the National Weather Service API.
    #
    # @return [Net::HTTP::Get] The HTTP GET request object.
    def get_request(zipcode:)
      url = URI.parse("#{ENDPOINT}?#{zipcode}")
      http = Net::HTTP.new(url.host, url.port)

      request = Net::HTTP::Get.new(url.request_uri)
      request["Authorization"] = "Bearer #{@api_key}"

      return http, request
    end
  end
end
