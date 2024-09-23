class BookSearchService
  BASE_URL = 'https://openlibrary.org/search.json'

  def self.search_books(location, quantity)
    response = Faraday.get(BASE_URL, { q: location, limit: quantity })
    JSON.parse(response.body, symbolize_names: true)[:docs]
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("BookSearchService Error: #{e.message}")
    []
  end
end