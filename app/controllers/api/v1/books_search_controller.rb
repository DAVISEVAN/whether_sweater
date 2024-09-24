class Api::V1::BooksSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i

    if quantity <= 0
      render json: { error: 'Quantity must be a positive integer greater than 0' }, status: :bad_request
      return
    end

    lat, lng = GeocodingService.get_coordinates(location) 
    weather_data = WeatherService.get_forecast(lat, lng)
    forecast = parse_forecast(weather_data)

    books_data = BookSearchService.new(location, quantity).fetch_books

    if books_data[:error]
      render json: { error: books_data[:error] }, status: :bad_request
    else
      render json: BookSearchSerializer.new(location, forecast, books_data).serialize_response
    end
  end

  private

  def parse_forecast(weather_data)
    {
      summary: weather_data.dig(:current, :condition, :text) || 'No Summary Available',
      temperature: weather_data.dig(:current, :temp_f).present? ? "#{weather_data.dig(:current, :temp_f)} F" : 'No Temperature Available'
    }
  end
end