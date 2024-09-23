require 'rails_helper'

RSpec.describe 'Book Search API', type: :request do
  describe 'GET /api/v1/book-search' do
    context 'when the request is valid' do
      it 'returns books about the destination city along with current forecast' do
        get '/api/v1/book-search?location=denver,co&quantity=5'

        expect(response).to be_successful
        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:data][:type]).to eq('books')
        expect(data[:data][:attributes][:destination]).to eq('denver,co')
        expect(data[:data][:attributes][:forecast]).to have_key(:summary)
        expect(data[:data][:attributes][:forecast]).to have_key(:temperature)
        expect(data[:data][:attributes][:total_books_found]).to be_a(Integer)
        expect(data[:data][:attributes][:books].size).to eq(5)

        book = data[:data][:attributes][:books].first
        expect(book).to have_key(:isbn)
        expect(book).to have_key(:title)
        expect(book).to have_key(:publisher)
      end
    end

    context 'when the quantity is invalid' do
      it 'returns a 400 status code' do
        get '/api/v1/book-search?location=denver,co&quantity=-1'

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include("Quantity must be a positive integer")
      end
    end
  end
end