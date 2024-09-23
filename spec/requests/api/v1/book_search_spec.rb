require 'rails_helper'

RSpec.describe 'Book Search API', type: :request do
  describe 'GET /api/v1/book-search' do
    context 'when the request is valid' do
      it 'returns books about the destination city along with current forecast' do
        # Mock the Geocoding API response
        stub_request(:get, /mapquestapi.com/)
          .with(query: hash_including({ 'location' => 'denver,co' }))
          .to_return(
            status: 200,
            body: {
              results: [
                {
                  locations: [
                    {
                      latLng: { lat: 39.7392, lng: -104.9903 }
                    }
                  ]
                }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # Mock the Weather API response
        stub_request(:get, /weatherapi.com/)
          .with(query: hash_including({ 'q' => '39.7392,-104.9903' }))
          .to_return(
            status: 200,
            body: {
              current: {
                condition: { text: 'Sunny' },
                temp_f: 75.2
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        # Mock the Open Library API response
        stub_request(:get, /openlibrary.org/)
          .with(query: hash_including({ 'q' => 'denver,co' }))
          .to_return(
            status: 200,
            body: {
              numFound: 172,
              docs: [
                {
                  title: 'Denver, Co',
                  publisher: ['Penguin Books'],
                  isbn: ['0762507845', '9780762507849']
                },
                {
                  title: 'Photovoltaic safety, Denver, CO, 1988',
                  publisher: ['American Institute of Physics'],
                  isbn: ['9780883183663', '0883183668']
                }
                # Add more mock books later
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        get '/api/v1/book-search', params: { location: 'denver,co', quantity: 5 }

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body[:data][:attributes][:destination]).to eq('denver,co')
        expect(response_body[:data][:attributes][:forecast][:summary]).to eq('Sunny')
        expect(response_body[:data][:attributes][:forecast][:temperature]).to eq('75.2 F')
        expect(response_body[:data][:attributes][:total_books_found]).to eq(172)
        expect(response_body[:data][:attributes][:books].size).to eq(5)
      end
    end
  end
end