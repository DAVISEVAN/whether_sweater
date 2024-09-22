class GeocodingService
  def self.get_coordinates(location)
    response = Faraday.get("http://www.mapquestapi.com/geocoding/v1/address") do |req|
      req.params['key'] = Rails.application.credentials[:mapquest_api_key] # Updated to use Rails credentials
      req.params['location'] = location
    end

    data = JSON.parse(response.body, symbolize_names: true)

    if data[:results].any? && data[:results][0][:locations].any?
      {
        lat: data[:results][0][:locations][0][:latLng][:lat],
        lng: data[:results][0][:locations][0][:latLng][:lng]
      }
    else
      { lat: nil, lng: nil }
    end
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("GeocodingService Error: #{e.message}")
    { lat: nil, lng: nil }
  end
end