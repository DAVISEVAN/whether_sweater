class Api::V1::RoadTripsController < ApplicationController
  before_action :validate_api_key

  def create
    road_trip = RoadTripFacade.create_road_trip(params[:origin], params[:destination])

    render json: RoadTripSerializer.new(road_trip).serialized_json, status: :ok
  end

  private

  def validate_api_key
    api_key = params[:api_key]

    unless User.exists?(api_key: api_key)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end