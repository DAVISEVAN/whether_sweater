require 'rails_helper'

RSpec.describe UserAuthenticationService do
  describe '.call' do
    it 'successfully authenticates a user with correct credentials' do
      user = User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password', api_key: SecureRandom.hex)

      service = UserAuthenticationService.call(user.email, 'password')

      expect(service.success?).to be(true)
      expect(service.user).to eq(user)
    end

    it 'returns error messages when authentication fails' do
      service = UserAuthenticationService.call('invalid@example.com', 'wrongpassword')

      expect(service.success?).to be(false)
      expect(service.error_messages).to include('Invalid credentials')
    end
  end
end
