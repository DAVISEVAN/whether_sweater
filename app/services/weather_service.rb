class WeatherService
  def self.get_forecast(lat, lng)
    response = Faraday.get("http://api.weatherapi.com/v1/forecast.json") do |req|
      req.params['key'] = Rails.application.credentials[:weather_api_key] # Updated to use Rails credentials
      req.params['q'] = "#{lat},#{lng}"
      req.params['days'] = 5
      req.params['aqi'] = 'no'
    end

    JSON.parse(response.body, symbolize_names: true)
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("WeatherService Error: #{e.message}")
    {}
  end
end