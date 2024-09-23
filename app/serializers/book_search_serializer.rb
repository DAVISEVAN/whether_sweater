class BookSearchSerializer
  def initialize(location, forecast, books_data)
    @location = location
    @forecast = forecast
    @books_data = books_data
  end

  def serialize_response
    {
      data: {
        id: 'null',
        type: 'books',
        attributes: {
          destination: @location,
          forecast: {
            summary: @forecast[:summary],
            temperature: @forecast[:temperature]
          },
          total_books_found: @books_data[:total_books_found],
          books: @books_data[:books]
        }
      }
    }
  end
end