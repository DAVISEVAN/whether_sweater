class BookSearchService
  BASE_URL = "https://openlibrary.org/search.json"

  def self.search_books(location, quantity)
    response = Faraday.get(BASE_URL) do |req|
      req.params['q'] = location
      req.params['limit'] = quantity
    end

    JSON.parse(response.body, symbolize_names: true)
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("BookSearchService Error: #{e.message}")
    { docs: [] } # Return an empty collection if there's an error
  end
end