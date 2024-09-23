class Api::V1::BookSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i

    # Fetch coordinates for the location
    coordinates = GeocodingService.get_coordinates(location)
    
    # Fetch the current weather forecast using the coordinates
    forecast = WeatherService.get_forecast(coordinates[:lat], coordinates[:lng])

    # Fetch books related to the location 
    books_data = OpenLibraryService.search_books(location)

    # Limit books based on the quantity parameter
    books = books_data.first(quantity)

    render json: BookSearchSerializer.new(location, forecast, books_data.size, books)
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end