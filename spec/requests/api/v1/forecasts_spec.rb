require 'rails_helper'

RSpec.describe "Api::V1::Forecasts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/forecasts/show"
      expect(response).to have_http_status(:success)
    end
  end

end
