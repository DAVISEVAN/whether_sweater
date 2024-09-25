require 'rails_helper'

RSpec.describe 'Books Search API', type: :request do
  describe 'GET /api/v1/book-search' do
    context 'when the request is valid' do
      before do
        # Create a BookSearch instance with forecast and books data for stubbing
        books_data = JSON.parse(File.read('spec/fixtures/book_search_response.json'), symbolize_names: true)[:data][:attributes]
        book_search = BookSearch.new(
          'denver,co',
          { summary: 'Partly cloudy', temperature: '67.1 F' },
          books_data
        )

        # Stub the facade to return the BookSearch instance
        allow(BooksSearchFacade).to receive(:fetch_data).and_return(book_search)
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
        # Create a BookSearch instance with default forecast and empty books data
        books_data = { total_books_found: 0, books: [] }
        book_search = BookSearch.new(
          'denver,co',
          { summary: 'No Summary Available', temperature: 'No Temperature Available' },
          books_data
        )

        # Stub the facade to return the BookSearch instance simulating failure or empty response
        allow(BooksSearchFacade).to receive(:fetch_data).and_return(book_search)
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