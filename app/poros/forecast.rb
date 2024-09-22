class Forecast
  attr_reader :current_weather, :daily_weather, :hourly_weather

  def initialize(data)
    @current_weather = format_current_weather(data[:current])
    @daily_weather = format_daily_weather(data[:forecast][:forecastday])
    @hourly_weather = format_hourly_weather(data[:forecast][:forecastday].first[:hour])
  end

  private

  def format_current_weather(current)
    {
      last_updated: current[:last_updated],
      temperature: current[:temp_f],
      condition: current[:condition][:text],
      icon: current[:condition][:icon],
      humidity: current[:humidity],
      feels_like: current[:feelslike_f],
      visibility: current[:vis_miles],
      uv_index: current[:uv]
    }
  end

  def format_daily_weather(forecast_days)
    forecast_days.map do |day|
      {
        date: day[:date],
        sunrise: day[:astro][:sunrise],
        sunset: day[:astro][:sunset],
        max_temp: day[:day][:maxtemp_f],
        min_temp: day[:day][:mintemp_f],
        condition: day[:day][:condition][:text],
        icon: day[:day][:condition][:icon]
      }
    end
  end

  def format_hourly_weather(hours)
    hours.map do |hour|
      {
        time: Time.parse(hour[:time]).strftime('%H:%M'), # Adjust time format
        temperature: hour[:temp_f],
        condition: hour[:condition][:text],
        icon: hour[:condition][:icon]
      }
    end
  end
end