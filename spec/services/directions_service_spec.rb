require 'rails_helper'

RSpec.describe DirectionsService do
  describe '.get_route' do
    it 'returns a failed route response when status code is missing' do
      allow(Faraday).to receive(:get).and_return(double(body: '{}'))
      result = DirectionsService.get_route('origin', 'destination')
      expect(result[:info][:statuscode]).to eq(500)
    end

    it 'logs an error when the API call fails' do
      allow(Faraday).to receive(:get).and_raise(Faraday::Error)
      expect(Rails.logger).to receive(:error).with(/DirectionsService Error/)
      DirectionsService.get_route('origin', 'destination')
    end
  end
end