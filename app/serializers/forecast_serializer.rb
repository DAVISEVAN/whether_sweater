class ForecastSerializer
  include JSONAPI::Serializer
  
  set_id { nil }
  set_type :forecast

  attributes :current_weather, :daily_weather, :hourly_weather

  def initialize(forecast)
    @forecast = forecast
  end

  def serialized_json
    {
      data: {
        id: nil,
        type: 'forecast',
        attributes: {
          current_weather: @forecast.current_weather,
          daily_weather: @forecast.daily_weather,
          hourly_weather: @forecast.hourly_weather
        }
      }
    }.to_json
  end
end