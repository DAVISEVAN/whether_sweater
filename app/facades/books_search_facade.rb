class BooksSearchFacade
  def self.fetch_data(location, quantity)
    coordinates = GeocodingService.get_coordinates(location)
    weather_data = WeatherService.get_forecast(coordinates[:lat], coordinates[:lng])
    forecast = parse_forecast(weather_data)
    books_data = BookSearchService.new(location, quantity).fetch_books

    { forecast: forecast, books: books_data }
  rescue StandardError => e
    { error: e.message }
  end

  def self.parse_forecast(weather_data)
    {
      summary: weather_data.dig(:current, :condition, :text) || 'No Summary Available',
      temperature: weather_data.dig(:current, :temp_f).present? ? "#{weather_data.dig(:current, :temp_f)} F" : 'No Temperature Available'
    }
  end
end
