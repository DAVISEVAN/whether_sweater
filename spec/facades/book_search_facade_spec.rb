require 'rails_helper'

RSpec.describe BooksSearchFacade do
  describe '.fetch_data' do
    it 'returns a BookSearch object with errors when WeatherService raises an error' do
      # Stubbing the external services to simulate error behavior
      allow(GeocodingService).to receive(:get_coordinates).and_return({ lat: 39.7392, lng: -104.9903 })
      allow(WeatherService).to receive(:get_forecast).and_raise(StandardError, 'Error message')

      result = BooksSearchFacade.fetch_data('denver,co', 5)

      expect(result.error?).to be(true)
      expect(result.error_message).to eq('Error message')
    end
  end
end