# README

Simple Rails application to lookup weather data by zipcode.

Weather data will be cached for 30 mintues per zip code.

## Weather API

Instead of using an external API that would require the evaluator to register an account with
I chose to include an API that will generate random weather data. 
Weather API is located at app/api/v1/national_weather_service and accessed via 
GET at http://localhost:3000/api/v1/national_weather_service/for_zipcode

It returns a random set of data. Due to the random nature it does not bother
to do anything with the passed in paramater(zipcode).

This returns a JSON payload containing:

```json
{
    temperature: {
        low: -14,
        high: 103,
        current: -5
    },
    temperature_unit: "fahrenheit",
    zip_code: "24462-5263"
}
```

Responds to GET /api/v1/national_weather_service/for_zipcode

### Running

This is a standard rails application, so you can access it like any other application.

- `bundle install`
- `bin/dev`
- http://localhost:3000
- http://localhost:3000/api/v1/national_weather_service/for_zipcode
