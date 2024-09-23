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
          forecast: {
            summary: @weather_data[:current][:condition][:text],
            temperature: "#{@weather_data[:current][:temp_f]} F"
          },
          total_books_found: @books_data[:num_found],
          books: format_books(@books_data[:docs])
        }
      }
    }
  end

  private

  def format_books(books)
    books.map do |book|
      {
        isbn: book[:isbn] || [],
        title: book[:title],
        publisher: book[:publisher] || []
      }
    end
  end
end