module LookupService
  API_KEY = Rails.application.credentials.national_weather_service.api_key || ""
  DEFAULT_CACHE_TIMEFRAME = 30.minutes.ago

  # Returns an instance of the NationalWeatherService API.
  #
  # @return [Apis::NationalWeatherService] The NationalWeatherService API instance.
  def self.api
    @api ||= Apis::NationalWeatherService.new(api_key: API_KEY)
  end

  # Builds a Lookup object based on the provided zipcode.
  #
  # @param zipcode [String] The zipcode to build the Lookup object for.
  # @return [ActiveRecordModel] The built Lookup object.
  def self.build(zipcode:)
    cached = find_cached(zipcode: zipcode.to_i)
    lookup = Lookup.new(zipcode: zipcode.to_i, lookup_id: nil)

    lookup.lookup_id = cached.id if cached

    lookup
  end

  # Finds a cached lookup record by zipcode.
  #
  # @param zipcode [String] The zipcode to search for.
  # @return [Lookup, nil] The cached lookup record if found, nil otherwise.
  def self.find_cached(zipcode:)
    records = Lookup
      .where("created_at > ?", DEFAULT_CACHE_TIMEFRAME)
      .where(zipcode: zipcode.to_i)
      .order("created_at DESC")
      .limit(1)

    records.any? ? records.first : nil
  end

  # Looks up weather information by zipcode.
  #
  # @param zipcode [String] The zipcode to lookup.
  # @return [Lookup] The lookup object decorated weather information if successful.
  def self.lookup_by_zipcode(zipcode:)
    lookup = build(zipcode: zipcode)

    # No point in going any further if the lookup is not valid
    return lookup unless lookup.valid?

    # Do not need to waste resources hitting the API. We found a cahced resource
    return lookup if lookup.lookup_id

    lookup.data = api.for_zipcode(zipcode: zipcode)

    lookup
  end
end
