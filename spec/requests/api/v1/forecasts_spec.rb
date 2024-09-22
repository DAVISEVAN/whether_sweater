require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Forecast API', type: :request do
  describe 'GET /api/v1/forecast' do
    context 'when the location is valid' do
      it 'returns the correct weather data for a city' do
        stub_request(:get, /mapquestapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/mapquest_success.json'))
        stub_request(:get, /weatherapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/weather_success.json'))

        get '/api/v1/forecast', params: { location: 'Sacramento,CA' }

        expect(response).to be_successful
        forecast = JSON.parse(response.body, symbolize_names: true)
        expect(forecast[:data][:attributes]).to include(:current_weather, :daily_weather, :hourly_weather)
      end
    end

    context 'when the location is invalid' do
      it 'returns an error message' do
        stub_request(:get, /mapquestapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/mapquest_invalid_location.json'))

        get '/api/v1/forecast', params: { location: 'invalidlocation' }

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to match(/Invalid location/)
      end
    end
  end
end