require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService, type: :service do
  describe '.get_forecast' do
    context 'when the coordinates are valid' do
      it 'retrieves weather data for given coordinates' do
        stub_request(:get, /weatherapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/weather_success.json'))

        forecast_data = WeatherService.get_forecast(38.58, -121.49)
        expect(forecast_data).to include(:current, :forecast)
      end
    end

    context 'when the API key is invalid' do
      it 'returns an empty hash' do
        stub_request(:get, /weatherapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/weather_invalid_key.json'))

        forecast_data = WeatherService.get_forecast(38.58, -121.49)
        expect(forecast_data).to include(:error)
        expect(forecast_data[:error][:message]).to eq('API key has been disabled.')
      end
    end
  end
end