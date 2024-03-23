module Apis
  module Stubs
    COLDEST_US_RECORDED_TEMPERATURE = -80
    HOTEST_US_RECORD_TEMPERATURE = 134

    def self.set_seed(seed:)
      @seed = seed
    end

    def self.temperatures
      low = low_temperature
      high = high_temperature(low: low)
      current = current_temperature(low: low, high: high)

      { low:, high:, current: }
    end

    def self.current_temperature(low:, high:)
      rand(low..high)
    end

    def self.high_temperature(low: COLDEST_US_RECORDED_TEMPERATURE, high: HOTEST_US_RECORD_TEMPERATURE)
      rand(low..high)
    end

    def self.low_temperature(low: COLDEST_US_RECORDED_TEMPERATURE, high: HOTEST_US_RECORD_TEMPERATURE)
      rand(low..high)
    end

    def self.zipcode
      Faker::Address.zip_code
    end

    def self.request
      srand(@seed) if @seed

      {
        temperature: temperatures,
        temperature_unit: :fahrenheit,
        zip_code: zipcode,
      }
    end
  end
end
