class ForecastFacade
  def self.fetch_forecast(location)
    coordinates = GeocodingService.get_coordinates(location)
    # Return nil if coordinates are missing, indicating an invalid location
    return nil if coordinates[:lat].nil? || coordinates[:lng].nil?

    forecast_data = WeatherService.get_forecast(coordinates[:lat], coordinates[:lng])
    Forecast.new(forecast_data)
  rescue StandardError
    nil # Return nil on any unexpected errors
  end
end