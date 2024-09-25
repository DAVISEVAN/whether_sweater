require 'rails_helper'

RSpec.describe 'User Login', type: :request do
  let!(:user) { User.create(email: 'whatever@example.com', password: 'password', password_confirmation: 'password', api_key: SecureRandom.hex) }

  describe 'POST /api/v1/sessions' do
    context 'when the request is valid' do
      before do
        # Stub the UserAuthenticationService to ensure it's called correctly
        allow(UserAuthenticationService).to receive(:call).and_return(
          double(success?: true, user: user, error_messages: [])
        )
      end

      it 'logs in the user and returns a 200 status' do
        post '/api/v1/sessions', params: {
          email: 'whatever@example.com',
          password: 'password'
        }.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(json_response[:data][:attributes][:email]).to eq('whatever@example.com')
        expect(json_response[:data][:attributes][:api_key]).to eq(user.api_key)
      end
    end

    context 'when the request is invalid' do
      before do
        # Stub the UserAuthenticationService to simulate an invalid login attempt
        allow(UserAuthenticationService).to receive(:call).and_return(
          double(success?: false, user: nil, error_messages: ['Invalid credentials'])
        )
      end

      it 'returns a 401 status with an error message' do
        post '/api/v1/sessions', params: {
          email: 'whatever@example.com',
          password: 'wrongpassword'
        }.to_json, headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body, symbolize_names: true)
        
        expect(json_response[:errors]).to include('Invalid credentials')
      end
    end
  end
end