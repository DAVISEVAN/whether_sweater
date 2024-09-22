require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GeocodingService, type: :service do
  describe '.get_coordinates' do
    context 'when the location is valid' do
      it 'retrieves latitude and longitude for a given location' do
        stub_request(:get, /mapquestapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/mapquest_success.json'))

        coordinates = GeocodingService.get_coordinates('Sacramento,CA')
        expect(coordinates[:lat]).to be_a(Float)
        expect(coordinates[:lng]).to be_a(Float)
      end
    end

    context 'when the location is invalid' do
      it 'returns nil values for latitude and longitude' do
        stub_request(:get, /mapquestapi.com/)
          .to_return(status: 200, body: File.read('spec/fixtures/mapquest_invalid_location.json'))

        coordinates = GeocodingService.get_coordinates('invalidlocation')
        expect(coordinates[:lat]).to be_nil
        expect(coordinates[:lng]).to be_nil
      end
    end
  end
end