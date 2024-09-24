class DirectionsService
  def self.get_route(origin, destination)
    response = Faraday.get("http://www.mapquestapi.com/directions/v2/route") do |req|
      req.params['key'] = Rails.application.credentials[:mapquest_api_key]
      req.params['from'] = origin
      req.params['to'] = destination
    end

    JSON.parse(response.body, symbolize_names: true)
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("DirectionsService Error: #{e.message}")
    { info: { statuscode: 500 } }
  end
end