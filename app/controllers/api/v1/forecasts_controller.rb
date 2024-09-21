class Api::V1::ForecastsController < ApplicationController
  def show
    location = params[:location]
    coordinates = GeocodingService.get_coordinates(location)
    forecast_data = WeatherService.get_forecast(coordinates)
    render json: ForecastSerializer.new(forecast_data)
  end
end
