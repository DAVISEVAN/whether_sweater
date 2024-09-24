class DirectionsService
  def self.get_route(origin, destination)
    response = Faraday.get("http://www.mapquestapi.com/directions/v2/route") do |req|
      req.params['key'] = Rails.application.credentials[:mapquest_api_key]
      req.params['from'] = origin
      req.params['to'] = destination
    end

    data = JSON.parse(response.body, symbolize_names: true) rescue {}

    
    Rails.logger.info("Mocked Directions API Response: #{data}")

   
    status_code = data.dig(:info, :statuscode)
    if status_code.nil?
      Rails.logger.error("Invalid API response format or missing status code: #{data}")
      return { info: { statuscode: 500 }, route: nil }
    end

    Rails.logger.info("Directions API Response Status: #{status_code}")

    if status_code == 0 && data[:route].present?
      Rails.logger.info("Handling as a possible route with travel time: #{data[:route][:formattedTime]}")
      data
    else
      Rails.logger.info("Handling as an impossible route due to missing or incomplete data.")
      { info: { statuscode: status_code }, route: nil }
    end
  rescue Faraday::Error => e
    Rails.logger.error("DirectionsService Error: #{e.message}")
    { info: { statuscode: 500 }, route: nil }
  end
end