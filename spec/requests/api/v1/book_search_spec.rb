require 'rails_helper'

RSpec.describe 'Books Search API', type: :request do
  describe 'GET /api/v1/book-search' do
    context 'when the request is valid' do
      before do
        # Stub the services to avoid actual API calls
        allow(GeocodingService).to receive(:get_coordinates).and_return([39.7392, -104.9903])
        
        allow(WeatherService).to receive(:get_forecast).and_return(
          current: {
            condition: { text: 'Partly cloudy' },
            temp_f: 67.1
          }
        )

        allow(BookSearchService).to receive(:new).and_return(
          instance_double(BookSearchService, fetch_books: JSON.parse(File.read('spec/fixtures/book_search_response.json'), symbolize_names: true)[:data][:attributes])
        )
      end

      it 'returns the correct book search response' do
        get '/api/v1/book-search', params: { location: 'denver,co', quantity: 5 }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:data][:attributes][:destination]).to eq('denver,co')
        expect(json_response[:data][:attributes][:forecast][:summary]).to eq('Partly cloudy')
        expect(json_response[:data][:attributes][:forecast][:temperature]).to eq('67.1 F')
        expect(json_response[:data][:attributes][:total_books_found]).to eq(5)
        expect(json_response[:data][:attributes][:books].size).to eq(5)
        expect(json_response[:data][:attributes][:books].first[:title]).to eq('Denver, Co')
        expect(json_response[:data][:attributes][:books].first[:isbn]).to include('9780762507849', '0762507845')
      end
    end
  end
end