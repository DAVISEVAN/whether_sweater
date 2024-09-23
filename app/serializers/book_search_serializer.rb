class BookSearchSerializer
  def initialize(location, weather_data, books_data)
    @location = location
    @weather_data = weather_data
    @books_data = books_data
  end

  def serialized_json
    {
      data: {
        id: nil,
        type: 'books',
        attributes: {
          destination: @location,
          forecast: format_forecast(@weather_data),
          total_books_found: @books_data[:num_found],
          books: format_books(@books_data[:docs] || []) # Ensure docs is an array
        }
      }
    }
  end

  private

  def format_forecast(weather_data)
    {
      summary: weather_data.dig(:current, :condition, :text) || "Summary unavailable",
      temperature: "#{weather_data.dig(:current, :temp_f) || 'N/A'} F"
    }
  rescue NoMethodError
    { summary: "Data unavailable", temperature: "N/A" }
  end

  def format_books(books)
    books.map do |book|
      {
        isbn: Array(book[:isbn]), # Ensure isbn is always an array
        title: book[:title] || "Unknown Title",
        publisher: Array(book[:publisher]) # Ensure publisher is always an array
      }
    end
  rescue NoMethodError => e
    Rails.logger.error("Error formatting books: #{e.message}")
    []
  end
end