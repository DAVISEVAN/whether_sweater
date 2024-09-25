require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  describe 'POST /api/v1/users' do
    context 'when the request is valid' do
      let(:valid_attributes) { { user: { email: 'whatever@example.com', password: 'password', password_confirmation: 'password' } } }

      it 'creates a user and returns a 201 status' do
        post '/api/v1/users', params: valid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(json_response[:data][:attributes][:email]).to eq('whatever@example.com')
        expect(json_response[:data][:attributes]).to have_key(:api_key)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { user: { email: 'whatever@example.com', password: 'password', password_confirmation: 'wrongpassword' } } }

      it 'returns a 400 status when passwords do not match' do
        post '/api/v1/users', params: invalid_attributes.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(json_response[:errors]).to include("Password confirmation doesn't match Password")
      end
    end
  end
end