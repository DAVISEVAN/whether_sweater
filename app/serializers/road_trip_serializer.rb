class RoadTripSerializer
  include JSONAPI::Serializer

  set_id { nil }
  set_type :roadtrip

  attributes :start_city, :end_city, :travel_time, :weather_at_eta

  def initialize(road_trip)
    @road_trip = road_trip
  end

  def serialized_json
    {
      data: {
        id: nil,
        type: 'roadtrip',
        attributes: {
          start_city: @road_trip.start_city,
          end_city: @road_trip.end_city,
          travel_time: @road_trip.travel_time,
          weather_at_eta: @road_trip.weather_at_eta
        }
      }
    }.to_json
  end
end