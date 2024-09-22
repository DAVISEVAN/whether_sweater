class Api::V1::ForecastsController < ApplicationController
  def show
    location = params[:location]
    coordinates = GeocodingService.get_coordinates(location)

    if coordinates[:lat].nil? || coordinates[:lng].nil?
      render json: { error: 'Invalid location' }, status: :bad_request
    else
      forecast_data = WeatherService.get_forecast(coordinates[:lat], coordinates[:lng])
      forecast = Forecast.new(forecast_data)
      render json: ForecastSerializer.new(forecast).serialized_json
    end
  end
end