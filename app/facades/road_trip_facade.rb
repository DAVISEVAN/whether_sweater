class RoadTripFacade
  def self.create_road_trip(origin, destination)
    route_data = DirectionsService.get_route(origin, destination)

    if route_data[:info][:statuscode] == 0
      travel_time = route_data[:route][:formattedTime]
      end_location = route_data[:route][:locations].last[:latLng]
      weather_data = WeatherService.get_forecast(end_location[:lat], end_location[:lng])

      eta = calculate_eta(weather_data, travel_time)
      RoadTrip.new(origin, destination, travel_time, eta)
    else
      RoadTrip.new(origin, destination, "impossible route", {})
    end
  end

  def self.calculate_eta(weather_data, travel_time)
    hours, minutes, _seconds = travel_time.split(':').map(&:to_i)
    total_hours = hours + (minutes / 60.0).round

    eta_weather = weather_data[:forecast][:forecastday].flat_map { |day| day[:hour] }[total_hours]

    
    if eta_weather.nil?
      {}
    else
      {
        datetime: eta_weather[:time],
        temperature: eta_weather[:temp_f],
        condition: eta_weather[:condition][:text]
      }
    end
  rescue
    
    {}
  end
end