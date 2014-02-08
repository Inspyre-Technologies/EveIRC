require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'cinch/toolbox'

module Cinch
  module Plugins
    class Weather
      include Cinch::Plugin
    
      set :required_options, [:key]
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Check the weather right from the IRC channel!
        Usage:
        * !weather <location>: The bot will check the weather for the location you provide!
      USAGE
    
      match /weather (.+)/i, method: :current
    
      def current(m, query)
        query.gsub! /\s/, '+'
        geometry = geolookup(query)
        return m.reply "No results found for #{query}." if geometry.nil?
      
        data = get_current(geometry)
        return m.reply 'Uh oh, there was a problem getting the specified weather data. Try again later.' if data.nil?
      
        locale = location_r(query)
      
        m.reply(current_summary(data, locale))
      end
      
      # Fetch the location from Google Maps for the area the user is looking for to be passed into get_current.
      
      def geolookup(zipcode)
        raw_location = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{zipcode}&sensor=true").read)
        location = raw_location['results'][0]['geometry']['location']
        lat = location['lat']
        lng = location['lng']
        
        geometry = "#{lat},#{lng}"
      rescue
        nil
      end
      
      # Fetch the current weather data for the location found in geolookup.
      
      def get_current(geometry)
<<<<<<< HEAD
        key = config[:key]
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{geometry}").read)
=======
        apikey = "foo"
        data = JSON.parse(open("https://api.forecast.io/forecast/#{apikey}/#{geometry}").read)
>>>>>>> 18777609992663e779dd25a14efa81dbb8dc87ca
        current = data['currently']
        
        OpenStruct.new(
          conditions:    current['summary'],
          temp:          current['temperature'],
          feels_like:    current['apparentTemperature'],
          wind_speed:    current['windSpeed'],
          wind_bearing:  current['windBearing']
        )
        rescue
          nil
        end
      
      # We're gonna fetch the location data again so we can pass it into the results. Primitive, but it works.
      
      def location_r(location)
        raw_locale = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{location}&sensor=true").read)
        locale_city = raw_locale['results'][0]['address_components'][1]['long_name']
        locale_authority = raw_locale['results'][0]['address_components'][3]['long_name']
        locale_country = raw_locale['results'][0]['address_components'][4]['long_name']
        
        locale = "#{locale_city}, #{locale_authority}, #{locale_country}"
      end
    
      def current_summary(data, locale)
        # Converting Imperial for Metric, because it's sane when using a protocol like IRC to deliver this info
      
        temp_c = (data.temp - 32) * 5 / 9
        feels_temp_c = (data.feels_like - 32) * 5 / 9
        wind_speed_kph = data.wind_speed * 1.6
        temp_c = (temp_c*10).ceil/10.0
        feels_temp_c = (feels_temp_c*10).ceil/10.0
        wind_speed_kph = (wind_speed_kph*10).ceil/10.0
        
        # Now, deliver the info to IRC
        
        %Q{ #{locale} | Current Weather: #{data.conditions} | Temp: #{data.temp} F (#{temp_c} C) - Feels like: #{data.feels_like} F (#{feels_temp_c} C) | Wind: #{data.wind_speed} MPH (#{wind_speed_kph} KPH) - Bearing: #{data.wind_bearing}  } 
      end
    end
  end
end
