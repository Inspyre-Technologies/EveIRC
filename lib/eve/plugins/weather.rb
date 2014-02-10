require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'cinch/toolbox'

module Cinch
  module Plugins
    class Weather
      include Cinch::Plugin
      
      set :prefix, /^~/
      set :required_options, [:key]
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Check the weather right from the IRC channel!
        Usage:
        * !weather <location>: The bot will check the current weather for the location you provide!
        * !hourly <hour(s)> <location>: The bot will check the projected forecast for how many <hour(s)> away!
        * !daily <day(s)> <location>: The bot will check the projected forecast for how many <day(s)> away!
      USAGE
   
      match /weather (.+)/i, method: :current
      match /hourly (.+?) (.+)/i, method: :hourly
      match /daily (.+?) (.+)/i, method: :daily
   
      def current(m, query)
        query.gsub! /\s/, '+'
        geometry = geolookup(query)
        return m.reply "No results found for #{query}." if geometry.nil?
        
        locale = location_r(query)
        
        data = get_current(geometry, locale)
        
        return m.reply 'Uh oh, there was a problem getting the specified weather data. Try again later.' if data.nil?
     
        m.reply(data)
      end
     
      # Now we introduce a method to get the hourly up to 24hrs.
     
      def hourly(m, hour, query)
        query.gsub! /\s/, '+'
        geometry = geolookup(query)
        return m.reply "No results found for #{query}." if geometry.nil?
       
        locale = location_r(query)
     
        data = get_hourly(hour, geometry, locale)
       
        return m.reply 'Oh no! There was a problem fetching the specified weather data. Please try again later.' if data.empty?              
       
        m.reply(hourly_summary(data,hour))
      end
     
      # Now we introduce a method to get the daily forecast.
     
      def daily(m, day, query)
        query.gsub! /\s/, '+'
        geometry = geolookup(query)
        return m.reply "No results found for #{query}." if geometry.nil?
       
        locale = location_r(query)
       
        data = get_daily(day, geometry, locale)
       
        return m.reply 'Oh no! There was a problem fetching the specified weather data. Please try again later.' if data.empty?
       
        m.reply(daily_summary(data,day))
      end
     
      # Fetch the location from Google Maps for the area the user is looking for to be passed into get_current.
     
      def geolookup(zipcode)
        raw_location = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{zipcode}&sensor=true").read)
        location = raw_location['results'][0]['geometry']['location']
        lat = location['lat']
        lng = location['lng']
       
        geometry = "#{lat},#{lng}"
        return geometry
      rescue
        nil
      end
     
      # Fetch the current weather data for the location found in geolookup.
     
      def get_current(geometry, locale)
        key = config[:key]
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{geometry}").read)
        current = data['currently']
       
        conditions = current['summary']
        temp = current['temperature']
        feels_like = current['apparentTemperature']
        wind_speed = current['windSpeed']
        wind_bearing = current['windBearing']
        
        temp_c = (temp - 32) * 5 / 9
        feels_temp_c = (feels_like - 32) * 5 / 9
        wind_speed_kph = wind_speed * 1.6
        temp_c = (temp_c * 10).ceil / 10.0
        feels_temp_c = (feels_temp_c * 10).ceil / 10.0
        wind_speed_kph = (wind_speed_kph * 10).ceil / 10.0
        
        return "10Weather: #{locale} | Current Weather: #{conditions} | Temp: #{temp} °F (#{temp_c} °C) - Feels like: #{feels_like} °F (#{feels_temp_c} °C) | Wind: #{wind_speed} MPH (#{wind_speed_kph} KPH) - Bearing: #{wind_bearing}"
        
        rescue
          nil
       end
       
      # Now we are going to fetch the hourly data.
     
      def get_hourly(hour, geometry, locale)
        key = config[:key]
        logo = "10Hourly Fore4cast:"
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{geometry}").read)
        raw_hourly = data['hourly']['data']
        hourly = []
        for i in raw_hourly
          sum = i['summary']
          temp = i['temperature']
          feels_temp = i['apparentTemperature']
          wind = i['windSpeed']
          bear = i['windBearing']

          temp_c = (temp - 32) * 5 / 9
          feels_temp_c = (feels_temp - 32) * 5 / 9
          wind_speed_kph = wind * 1.6
          temp_c = (temp_c * 10).ceil / 10.0
          feels_temp_c = (feels_temp_c * 10).ceil / 10.0
          wind_speed_kph = (wind_speed_kph * 10).ceil / 10.0
       
          hourly.push(("%s - #{locale}: Forecast Predicted in #{hour} hour(s): %s | Temp: [ %s °F (%s °C) | Will feel like: %s °F (%s °C) ] | Wind: [ Speed: %s MPH (%s KPH) | Bearing: %s ]" % [logo, sum, temp, temp_c, feels_temp, feels_temp_c, wind, wind_speed_kph, bear]))
        end
        return hourly
      end
     
      def hourly_summary(data, hour)
        return data[hour.to_i - 1]
      end
     
      # Now we are going to fetch the daily data.
     
      def get_daily(day, geometry, locale)
        key = config[:key]
        logo = "10Daily Fore4cast:"
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{geometry}").read)
        raw_daily = data['daily']['data']
        daily = []
        for i in raw_daily
          sum = i['summary']
          min = i['temperatureMin']
          max = i['temperatureMax']
          appmin = i['apparentTemperatureMin']
          appmax = i['apparentTemperatureMax']
          wind = i['windSpeed']
          bear = i['windBearing']
        
        # We're going to convert it to metric as well, because IRC.
        
          temp_c_max = (max - 32) * 5 / 9
          temp_c_min = (min - 32) * 5 / 9
          feels_temp_c_min = (appmin - 32) * 5 / 9
          feels_temp_c_max = (appmax - 32) * 5 / 9
          wind_speed_kph = wind * 1.6
          temp_c_max = (temp_c_max * 10).ceil / 10.0
          temp_c_min = (temp_c_min * 10).ceil / 10.0
          feels_temp_c_min = (feels_temp_c_min * 10).ceil / 10.0
          feels_temp_c_max = (feels_temp_c_max * 10).ceil / 10.0
          wind_speed_kph = (wind_speed_kph * 10).ceil / 10.0
         
          daily.push(("%s - #{locale}: Forecast Predicted in #{day} day(s): %s | Temp: [ 10Min: %s °F (10#{temp_c_min} °C) | 4Max: %s °F (4#{temp_c_max} °C) ] - Will Feel Like: [ 10Min: %s °F (10#{feels_temp_c_min} °C) | 4Max: %s °F (4#{feels_temp_c_max} °C) ] | Wind: [ Speed: %s MPH (#{wind_speed_kph} KPH) | Bearing: %s ]" % [logo, sum, min, max, appmin, appmax, wind, bear]))
        end
        return daily
      end
 
      def daily_summary(data, day)
        return data[day.to_i - 1]
      end
     
      # We're gonna fetch the location data again so we can pass it into the results. Primitive, but it works.
     
      def location_r(location)
        raw_locale = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{location}&sensor=true").read)
        locale_data = raw_locale['results'][0]['formatted_address']
       
        locale = "#{locale_data}"
      end

    end
  end
end
