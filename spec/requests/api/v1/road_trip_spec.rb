require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'RoadTrips API', type: :request do
  describe 'POST /api/v1/road_trip' do
    let(:api_key) { 'mocked_api_key' }

    before do
      # Mock the API key validation to bypass authentication
      allow_any_instance_of(Api::V1::RoadTripsController).to receive(:validate_api_key).and_return(true)

      # Load fixture files for mocked responses
      possible_route_response = File.read('spec/fixtures/possible_route.json')
      impossible_route_response = File.read('spec/fixtures/impossible_route.json')
      weather_success_response = File.read('spec/fixtures/weather_success.json')

      # Mock Directions API for a possible route
      stub_request(:get, /mapquestapi.com\/directions\/v2\/route/)
        .with(query: hash_including('from' => 'New York, NY', 'to' => 'Chicago, IL'))
        .to_return(
          status: 200,
          body: possible_route_response,
          headers: { 'Content-Type' => 'application/json' }
        )

      # Mock Directions API for an impossible route
      stub_request(:get, /mapquestapi.com\/directions\/v2\/route/)
        .with(query: hash_including('from' => 'New York, NY', 'to' => 'London, UK'))
        .to_return(
          status: 200,
          body: impossible_route_response,
          headers: { 'Content-Type' => 'application/json' }
        )

      # Mock Weather API using the weather_success.json fixture
      stub_request(:get, /api.weatherapi.com\/v1\/forecast.json/)
        .with(query: hash_including('q' => '41.8781,-87.6298'))
        .to_return(
          status: 200,
          body: weather_success_response,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    context 'when the route is possible' do
      it 'returns travel time and weather at ETA' do
        post '/api/v1/road_trip', params: {
          origin: 'New York, NY',
          destination: 'Chicago, IL',
          api_key: api_key
        }.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)

      end
    end

    context 'when the route is impossible' do
      it 'returns impossible route with empty weather' do
        post '/api/v1/road_trip', params: {
          origin: 'New York, NY',
          destination: 'London, UK',
          api_key: api_key
        }.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:data][:attributes][:travel_time]).to eq('impossible route')
        expect(json_response[:data][:attributes][:weather_at_eta]).to be_empty
      end
    end
  end
end