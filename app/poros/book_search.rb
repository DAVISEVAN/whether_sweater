class BookSearch
  attr_reader :location, :forecast, :total_books_found, :books

  def initialize(location, forecast, books_data, error: nil)
    @location = location
    @forecast = format_forecast(forecast)
    @total_books_found = books_data[:total_books_found]
    @books = books_data[:books]
    @error = error
  end

  def error?
    !@error.nil?
  end

  def error_message
    @error
  end

  private

  def format_forecast(forecast)
    {
      summary: forecast[:summary] || 'No Summary Available',
      temperature: forecast[:temperature] || 'No Temperature Available'
    }
  end
end