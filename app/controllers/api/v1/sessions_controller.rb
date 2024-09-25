class Api::V1::SessionsController < ApplicationController
  def create
    result = UserAuthenticationService.call(params[:email], params[:password])

    if result.success?
      render json: UserSerializer.new(result.user).serialized_json, status: :ok
    else
      render json: { errors: result.error_messages }, status: :unauthorized
    end
  end
end