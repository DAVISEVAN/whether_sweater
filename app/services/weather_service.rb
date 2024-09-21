class WeatherService
  def self.get_forecast(lat, lng)
    response = Faraday.get("https://api.weatherapi.com/v1/forecast.json") do |req|
      req.params['key'] = ENV['WEATHER_API_KEY']
      req.params['q'] = "#{lat},#{lng}"
      req.params['days'] = 5
      req.params['aqi'] = 'no'
      req.params['alerts'] = 'no'
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
