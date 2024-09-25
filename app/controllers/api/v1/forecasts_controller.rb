class Api::V1::ForecastsController < ApplicationController
  def show
    forecast = ForecastFacade.fetch_forecast(params[:location])

    # Check for nil forecast and render an error response if location is invalid
    if forecast.nil?
      render json: { error: 'Invalid location' }, status: :bad_request
    else
      render json: ForecastSerializer.new(forecast).serialized_json
    end
  end
end