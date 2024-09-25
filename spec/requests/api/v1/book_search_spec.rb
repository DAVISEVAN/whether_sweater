require 'rails_helper'

RSpec.describe 'Books Search API', type: :request do
  describe 'GET /api/v1/book-search' do
    context 'when the request is valid' do
      before do
        # Stub the facade instead of direct service calls
        allow(BooksSearchFacade).to receive(:fetch_data).and_return(
          forecast: {
            summary: 'Partly cloudy',
            temperature: '67.1 F'
          },
          books: JSON.parse(File.read('spec/fixtures/book_search_response.json'), symbolize_names: true)[:data][:attributes]
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

    context 'when the request is invalid or services fail' do
      before do
        # Stub the facade to simulate service failure or empty responses
        allow(BooksSearchFacade).to receive(:fetch_data).and_return(
          forecast: {
            summary: 'No Summary Available',
            temperature: 'No Temperature Available'
          },
          books: { total_books_found: 0, books: [] }
        )
      end

      it 'returns default forecast and empty book results' do
        get '/api/v1/book-search', params: { location: 'denver,co', quantity: 5 }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:data][:attributes][:destination]).to eq('denver,co')
        expect(json_response[:data][:attributes][:forecast][:summary]).to eq('No Summary Available')
        expect(json_response[:data][:attributes][:forecast][:temperature]).to eq('No Temperature Available')
        expect(json_response[:data][:attributes][:total_books_found]).to eq(0)
        expect(json_response[:data][:attributes][:books]).to be_empty
      end
    end
  end
end