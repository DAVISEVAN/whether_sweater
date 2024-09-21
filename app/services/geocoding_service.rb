class GeocodingService
  def self.get_coordinates(location)
    response = Faraday.get("http://www.mapquestapi.com/geocoding/v1/") do |req|
      req.params['key'] = ENV['MAPQUEST_API_KEY']
      req.params['location'] = location
    end
    json = JSON.parse(response.body, symbolize_names: true)
    lat_lng = json[:results][0][:locations][0][:latLng]
    { lat: lat_lng[:lat], lng: lat_lng[:lng] }
  end
end