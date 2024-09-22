require 'rails_helper'

RSpec.describe 'User Login', type: :request do
  let!(:user) { User.create(email: 'whatever@example.com', password: 'password', password_confirmation: 'password', api_key: SecureRandom.hex) }

  describe 'POST /api/v1/sessions' do
    context 'when the request is valid' do
      it 'logs in the user and returns a 200 status' do
        post '/api/v1/sessions', params: {
          email: 'whatever@example.com',
          password: 'password'
        }.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['attributes']['email']).to eq('whatever@example.com')
        expect(JSON.parse(response.body)['data']['attributes']['api_key']).to eq(user.api_key)
      end
    end

    context 'when the request is invalid' do
      it 'returns a 401 status with an error message' do
        post '/api/v1/sessions', params: {
          email: 'whatever@example.com',
          password: 'wrongpassword'
        }.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to include('Invalid credentials')
      end
    end
  end
end