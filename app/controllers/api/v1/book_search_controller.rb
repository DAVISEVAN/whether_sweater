class Api::V1::BookSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i

    # Fetch coordinates for the location
    coordinates = GeocodingService.get_coordinates(location)
    
    # Fetch the current weather forecast using the coordinates
    forecast = WeatherService.get_forecast(coordinates[:lat], coordinates[:lng])

    # Fetch books related to the location
    books_data = BookSearchService.search_books(location, quantity)

    # Render the response using the BookSearchSerializer with correct arguments
    render json: BookSearchSerializer.new(location, forecast, books_data).serialized_json
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end