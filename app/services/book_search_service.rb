class BookSearchService
  BASE_URL = "https://openlibrary.org/search.json"

  # Ensure the method accepts both location and quantity correctly
  def self.search_books(location, quantity)
    response = Faraday.get(BASE_URL) do |req|
      req.params['q'] = location
      req.params['limit'] = quantity
    end
    
    JSON.parse(response.body, symbolize_names: true)[:docs] # Extract docs to return relevant books
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("BookSearchService Error: #{e.message}")
    [] # Return an empty array if there's an error to avoid nil issues
  end
end