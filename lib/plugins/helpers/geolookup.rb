# frozen_string_literal: true

module Cinch
  module Helpers
    class NoResultsError < ArgumentError
      def message
        'There are no results for this location'
      end
    end

    def geolookup(_m, query)
      f_query = query.gsub /\s/, '+'
      results = []
      raw_location = JSON.parse(open("https://nominatim.openstreetmap.org/search?q=#{f_query}&format=json&addressdetails=1&limit=1").read)
      # puts raw_location
      location = raw_location[0]
      lat = location['lat']
      lng = location['lon']
      name = location['display_name']
      coords = "#{lat},#{lng}"
      raise NoResultsError if raw_location.empty?

      results = [coords, name]
      results
    rescue StandardError
      false
    rescue NoResultsError
      nil
    end
  end
end
