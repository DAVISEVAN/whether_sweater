require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Forecast API', type: :request do
  describe 'GET /api/v1/forecast' do
    context 'when the location is valid' do
      before do
        # Stub the ForecastFacade to return an instance of the Forecast object
        forecast_data = {
          current: {
            last_updated: '2024-09-25 14:00',
            temp_f: 72,
            condition: { text: 'Sunny', icon: 'sunny.png' },
            humidity: 50,
            feelslike_f: 70,
            vis_miles: 10,
            uv: 5
          },
          forecast: {
            forecastday: [
              {
                date: '2024-09-25',
                astro: { sunrise: '6:00 AM', sunset: '6:30 PM' },
                day: {
                  maxtemp_f: 75,
                  mintemp_f: 60,
                  condition: { text: 'Clear', icon: 'clear.png' }
                },
                hour: [
                  {
                    time: '2024-09-25 15:00',
                    temp_f: 73,
                    condition: { text: 'Sunny', icon: 'sunny.png' }
                  }
                ]
              }
            ]
          }
        }

        forecast = Forecast.new(forecast_data)
        allow(ForecastFacade).to receive(:fetch_forecast).and_return(forecast)
      end

      it 'returns the correct weather data for a city' do
        get '/api/v1/forecast', params: { location: 'Sacramento,CA' }

        expect(response).to be_successful
        forecast = JSON.parse(response.body, symbolize_names: true)
        expect(forecast[:data][:attributes]).to include(:current_weather, :daily_weather, :hourly_weather)
      end
    end

    context 'when the location is invalid' do
      before do
        
        allow(ForecastFacade).to receive(:fetch_forecast).and_return(nil)
      end
    
      it 'returns an error message' do
        get '/api/v1/forecast', params: { location: 'invalidlocation' }
    
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to match(/Invalid location/)
      end
    end
  end
end