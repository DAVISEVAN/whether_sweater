class RoadTripFacade
  def self.create_road_trip(origin, destination)
    route_data = DirectionsService.get_route(origin, destination)

    # Check if route data is missing, incomplete, or indicates an error
    if route_data[:route].nil? || route_data[:route][:formattedTime].nil? || route_data[:info][:statuscode] != 0
      Rails.logger.info("Detected an impossible route from #{origin} to #{destination}.")
      RoadTrip.new(origin, destination, "impossible route", {})
    else
      travel_time = route_data[:route][:formattedTime]
      end_location = route_data[:route][:locations].last[:latLng]
      weather_data = WeatherService.get_forecast(end_location[:lat], end_location[:lng])

      eta = calculate_eta(weather_data, travel_time)
      RoadTrip.new(origin, destination, travel_time, eta)
    end
  end

  def self.calculate_eta(weather_data, travel_time)
    hours, minutes, _seconds = travel_time.split(':').map(&:to_i)
    total_hours = hours + (minutes / 60.0).round

    eta_weather = weather_data[:forecast][:forecastday].flat_map { |day| day[:hour] }[total_hours]

    eta_weather.nil? ? {} : { datetime: eta_weather[:time], temperature: eta_weather[:temp_f], condition: eta_weather[:condition][:text] }
  rescue
    {}
  end
end