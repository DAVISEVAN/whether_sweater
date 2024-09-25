class BookSearchService
  OPEN_LIBRARY_URL = 'http://openlibrary.org/search.json'

  def initialize(location, quantity)
    @location = location
    @quantity = quantity
  end

  def fetch_books
    response = Faraday.get(OPEN_LIBRARY_URL, { q: @location })
    data = JSON.parse(response.body, symbolize_names: true)
    total_books_found = data[:num_found]
    books = data[:docs].first(@quantity).map do |book| 
      {
        isbn: book[:isbn]&.first(2) || [],
        title: book[:title] || 'No Title Available',
        publisher: book[:publisher] || ['No Publisher Available']
      }
    end
    { total_books_found: total_books_found, books: books }
  rescue Faraday::Error => e
    Rails.logger.error("BookSearchService Error: #{e.message}")
    { total_books_found: 0, books: [] }
  end
end