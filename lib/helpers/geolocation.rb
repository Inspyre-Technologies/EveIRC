require 'json'
require 'open-uri'
require_relative 'logger'

module Cinch
  module Helpers

    def geolocation(location)
      begin
        log_message("message", "Looking for #{location}...")
        formatted_location = location.gsub /\s/, '+'
        geo_page = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{formatted_location}&sensor=true").read)
        result = geo_page['results'][0]['geometry']['location']
        @lat = result['lat']
        @lng = result['lng']
        @address = geo_page['results'][0]['formatted_address']
        log_message("message", "Found top result: #{@address} | #{@lat},#{@lng}")
        return true
      rescue
        return false
      end
    end
  end
end