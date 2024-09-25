class BooksSearchFacade
  def self.fetch_data(location, quantity)
    coordinates = GeocodingService.get_coordinates(location)
    return BookSearch.new(location, { summary: 'No Summary Available', temperature: 'No Temperature Available' }, { total_books_found: 0, books: [] }, error: 'Invalid location') if coordinates[:lat].nil? || coordinates[:lng].nil?

    weather_data = WeatherService.get_forecast(coordinates[:lat], coordinates[:lng])
    books_data = BookSearchService.new(location, quantity).fetch_books

    # Return an instance of BookSearch instead of a hash
    BookSearch.new(location, format_forecast(weather_data), books_data)
  rescue StandardError => e
    # Handle errors and return an instance of BookSearch with error details
    BookSearch.new(location, { summary: 'No Summary Available', temperature: 'No Temperature Available' }, { total_books_found: 0, books: [] }, error: e.message)
  end

  private

  def self.format_forecast(weather_data)
    {
      summary: weather_data.dig(:current, :condition, :text) || 'No Summary Available',
      temperature: weather_data.dig(:current, :temp_f).present? ? "#{weather_data.dig(:current, :temp_f)} F" : 'No Temperature Available'
    }
  end
end