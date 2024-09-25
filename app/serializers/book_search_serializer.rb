class BookSearchSerializer
  def initialize(book_search)
    @book_search = book_search
  end

  def serialize_response
    {
      data: {
        id: 'null',
        type: 'books',
        attributes: {
          destination: @book_search.location,
          forecast: @book_search.forecast,
          total_books_found: @book_search.total_books_found,
          books: @book_search.books
        }
      }
    }.to_json
  end
end