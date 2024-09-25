require 'rails_helper'

RSpec.describe ForecastFacade do
  describe '.fetch_forecast' do
    it 'returns nil when GeocodingService raises an error' do
      allow(GeocodingService).to receive(:get_coordinates).and_raise(StandardError)
      result = ForecastFacade.fetch_forecast('invalidlocation')
      expect(result).to be_nil
    end

    it 'returns nil when GeocodingService returns nil coordinates' do
      allow(GeocodingService).to receive(:get_coordinates).and_return({ lat: nil, lng: nil })
      result = ForecastFacade.fetch_forecast('invalidlocation')
      expect(result).to be_nil
    end
  end
end