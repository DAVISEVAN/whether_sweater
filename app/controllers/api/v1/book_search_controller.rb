class Api::V1::BookSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i

    if quantity <= 0
      render json: { error: 'Quantity must be a positive integer' }, status: :bad_request
      return
    end

    weather_data = WeatherService.get_forecast(location)
    books_data = BookSearchService.search_books(location, quantity)

    render json: BookSearchSerializer.new(location, weather_data, books_data).serialized_json
  end
end