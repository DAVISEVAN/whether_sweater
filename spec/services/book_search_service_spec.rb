require 'rails_helper'

RSpec.describe BookSearchService do
  describe '#fetch_books' do
    let(:service) { BookSearchService.new('denver,co', 5) }

    context 'when the API call is successful' do
      before do
        response_body = {
          num_found: 100,
          docs: [
            { isbn: ['9780762507849', '0762507845'], title: 'Denver, Co', publisher: ['Universal Map Enterprises'] },
            { isbn: ['1703084756', '9781595478962'], title: 'Up from Slavery', publisher: ['Value Classic Reprints'] },
            { isbn: ['9780060541811', '0586050450'], title: 'The Andromeda Strain', publisher: ['Harper'] },
            { isbn: ['0762557362', '9780762557363'], title: 'Denver Co Deluxe Flip Map', publisher: ['Universal Map Enterprises'] },
            { isbn: ['9781427401687', '1427401683'], title: 'University of Denver Co 2007', publisher: ['College Prowler'] }
          ]
        }.to_json

        stub_request(:get, 'http://openlibrary.org/search.json')
          .with(query: { q: 'denver,co' })
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns the correct number of books and formats them correctly' do
        result = service.fetch_books

        expect(result[:total_books_found]).to eq(100)
        expect(result[:books].size).to eq(5)
        expect(result[:books].first).to eq({
          isbn: ['9780762507849', '0762507845'],
          title: 'Denver, Co',
          publisher: ['Universal Map Enterprises']
        })
      end
    end

    context 'when the API response is missing expected data' do
      before do
        response_body = {
          num_found: 0,
          docs: []
        }.to_json

        stub_request(:get, 'http://openlibrary.org/search.json')
          .with(query: { q: 'invalidlocation' })
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns zero books and handles empty data gracefully' do
        service = BookSearchService.new('invalidlocation', 5)
        result = service.fetch_books

        expect(result[:total_books_found]).to eq(0)
        expect(result[:books]).to eq([])
      end
    end

    context 'when the API call fails' do
      before do
        # Simulate a failed API call (network issue, timeout, etc.)
        stub_request(:get, 'http://openlibrary.org/search.json')
          .with(query: { q: 'denver,co' })
          .to_raise(Faraday::ConnectionFailed.new('Connection failed'))
      end

      it 'handles the error gracefully and returns empty data' do
        result = service.fetch_books
        expect(result[:total_books_found]).to eq(0)
        expect(result[:books]).to eq([])
      end
    end
  end
end