require 'rails_helper'

RSpec.describe WeatherService do
  describe '.get_forecast' do
    it 'logs an error and returns an empty hash when the API call fails' do
      allow(Faraday).to receive(:get).and_raise(Faraday::Error)
      expect(Rails.logger).to receive(:error).with(/WeatherService Error/)
      result = WeatherService.get_forecast(39.7392, -104.9903)
      expect(result).to eq({})
    end

    it 'returns forecast data when the API call is successful' do
      response = double(body: '{"forecast": {}}')
      allow(Faraday).to receive(:get).and_return(response)
      result = WeatherService.get_forecast(39.7392, -104.9903)
      expect(result).to include(:forecast)
    end
  end
end