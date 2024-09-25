class Api::V1::UsersController < ApplicationController
  def create
    puts "recieved params: #{params}"
    user = User.new(user_params)
    
    if user.save
      render json: UserSerializer.new(user).serialized_json, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end