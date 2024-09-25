class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :email, :api_key

  def initialize(user)
    @user = user
  end

  def serialized_json
    {
      data: {
        type: 'user',
        id: @user.id.to_s,
        attributes: {
          email: @user.email,
          api_key: @user.api_key
        }
      }
    }.to_json
  end
end