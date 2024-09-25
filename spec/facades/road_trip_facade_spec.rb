require 'rails_helper'

RSpec.describe RoadTripFacade do
  describe '.create_road_trip' do
    it 'returns a RoadTrip object with travel time and ETA when data is valid' do
      # Stubbing DirectionsService and WeatherService to provide valid data
      allow(DirectionsService).to receive(:get_route).and_return({
        route: { formattedTime: '02:00', locations: [{ latLng: { lat: 39.7392, lng: -104.9903 } }] },
        info: { statuscode: 0 }
      })

      # Ensure the stubbed weather data matches the expected structure
      allow(WeatherService).to receive(:get_forecast).and_return({
        forecast: {
          forecastday: [
            {
              hour: Array.new(24) { |i| { time: "2024-09-25 #{i}:00", temp_f: 70, condition: { text: 'Sunny' } } }
            }
          ]
        }
      })

      road_trip = RoadTripFacade.create_road_trip('origin', 'destination')

      expect(road_trip.start_city).to eq('origin')
      expect(road_trip.end_city).to eq('destination')
      expect(road_trip.travel_time).to eq('02:00')
      expect(road_trip.weather_at_eta).to eq({ datetime: '2024-09-25 2:00', temperature: 70, condition: 'Sunny' })
    end

    it 'returns a RoadTrip object with "impossible route" when route data is missing' do
      allow(DirectionsService).to receive(:get_route).and_return({ info: { statuscode: 500 }, route: nil })

      road_trip = RoadTripFacade.create_road_trip('origin', 'destination')

      expect(road_trip.start_city).to eq('origin')
      expect(road_trip.end_city).to eq('destination')
      expect(road_trip.travel_time).to eq('impossible route')
      expect(road_trip.weather_at_eta).to eq({})
    end
  end

  describe '.calculate_eta' do
    it 'returns the correct ETA weather data when valid weather data is provided' do
      weather_data = {
        forecast: {
          forecastday: [
            {
              hour: Array.new(24) { |i| { time: "2024-09-25 #{i}:00", temp_f: 70, condition: { text: 'Sunny' } } }
            }
          ]
        }
      }

      travel_time = '02:00'
      eta = RoadTripFacade.calculate_eta(weather_data, travel_time)

      expect(eta).to eq({ datetime: '2024-09-25 2:00', temperature: 70, condition: 'Sunny' })
    end

    it 'returns an empty hash when weather data is incomplete' do
      weather_data = { forecast: { forecastday: [] } }
      travel_time = '02:00'

      eta = RoadTripFacade.calculate_eta(weather_data, travel_time)

      expect(eta).to eq({})
    end
  end
end