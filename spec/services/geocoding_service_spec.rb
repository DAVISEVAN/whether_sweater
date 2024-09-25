require 'rails_helper'

RSpec.describe GeocodingService do
  describe '.get_coordinates' do
    it 'returns coordinates when location is valid' do
      response = double(body: '{"results": [{"locations": [{"latLng": {"lat": 39.7392, "lng": -104.9903}}]}]}')
      allow(Faraday).to receive(:get).and_return(response)

      result = GeocodingService.get_coordinates('denver,co')
      expect(result).to eq({ lat: 39.7392, lng: -104.9903 })
    end

    it 'returns nil coordinates when location is invalid' do
      response = double(body: '{"results": []}')
      allow(Faraday).to receive(:get).and_return(response)

      result = GeocodingService.get_coordinates('invalidlocation')
      expect(result).to eq({ lat: nil, lng: nil })
    end

    it 'logs an error and returns nil coordinates when the API call fails' do
      allow(Faraday).to receive(:get).and_raise(Faraday::Error)
      expect(Rails.logger).to receive(:error).with(/GeocodingService Error/)
      
      result = GeocodingService.get_coordinates('denver,co')
      expect(result).to eq({ lat: nil, lng: nil })
    end
  end
end