# frozen_string_literal: true

require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'yaml'
require 'cinch/toolbox'
require_relative 'config/check_auth'
require_relative 'config/check_ignore'
require_relative 'helpers/geolookup'

module Cinch
  module Plugins
    class Weather
      include Cinch::Plugin
      include Cinch::Helpers

      set :required_options, [:key]
      set :plugin_name, 'weather'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Check the weather right from the IRC channel!
      Usage:
      * !weather <location>: The bot will check the current weather for the location you provide!
      * !hourly <hour(s)> <location>: The bot will check the projected forecast for how many <hour(s)> away!
      * !daily <day(s)> <location>: The bot will check the projected forecast for how many <day(s)> away!
      ** If you have your location set with the bot you can use the following commands:
      * !w: Returns the weather for your saved location
      * !h <hour(s)>: Returns the projected forecast for how many hour(s) away, based on your saved location
      * !d <day(s)>: Returns the projected forecast for how many day(s) away, based on your saved location
      ** NOTE: If you don't have your location saved with the bot see !help userinfo for information on how to do so!
      USAGE

      def initialize(*args)
        super
        @storage = if File.exist?('docs/userinfo.yaml')
                     YAML.load_file('docs/userinfo.yaml')
                   else
                     {}
                   end
      end

      match /weather (.+)/i, method: :current
      match /hourly (.+?) (.+)/i, method: :hourly
      match /daily (.+?) (.+)/i, method: :daily

      match /w$/i, method: :custom_w
      match /h (.+)/i, method: :custom_h
      match /d (.+)/i, method: :custom_d

      match /cw (.+)/i, method: :check_custom

      def get_data(m, _query)
        data = geolookup(m, _query)
        if !data
          return false
        else
          @coords = data[0]
          @name   = data[1]
        end
      end

      def current(m, query)
        return if check_ignore(m.user)

        get_data(m, query)

        unless @coords
          m.reply 'There seems to have been a problem fetching your location data. Please try again later.'
        end

        data = get_current(@coords, @name, true) # true means we want locale printed

        unless data
          m.reply 'There seems to have been a problem fetching your weather data. Please try again later.'
        end

        m.reply(data)

        alerts = alert(@coords, @name, true)
        return m.user.notice 'You have no alerts.' if alerts.nil?

        m.user.notice(alerts)
      end

      # Now we introduce a method to get the hourly up to 24hrs.

      def hourly(m, hour, query)
        return if check_ignore(m.user)

        get_data(m, query)

        return m.reply "No results found for #{query}." if @coords.nil?

        data = get_hourly(hour, @coords, @name, true)

        return m.reply 'Oh no! There was a problem fetching the specified weather data. Please try again later.' if data.empty?

        m.reply(hourly_summary(data, hour))
      end

      # Now we introduce a method to get the daily forecast.

      def daily(m, day, query)
        return if check_ignore(m.user)

        get_data(m, query)

        return m.reply "No results found for #{query}." if @coords.nil?

        data = get_daily(day, @coords, @name, true)

        return m.reply 'Oh no! There was a problem fetching the specified weather data. Please try again later.' if data.empty?

        m.reply(daily_summary(data, day))
      end

      # Fetch the location from Google Maps for the area the user is looking for to be passed into get_current.

      def custom_w(m)
        return if check_ignore(m.user)

        w_user = m.user.nick
        reload
        if @storage.key?(w_user)
          stored_user = @storage[w_user]
          if stored_user.key? 'location_data'
            location_data = stored_user['location_data']

            coords = location_data['coords']

            name = location_data['name']

            data = get_current(coords, name, false) # false means we dont want locale printed

            c_alert = ifAlert(m, coords, name)

            return m.reply 'Oh no! There was a problem fetching the specified weather data for your custom location! Please try again later.' if data.nil?

            return m.reply(data)

            return c_alert
          end
        end
        m.reply 'You have no custom data set. You can PM me with !set-l <location>'
      end

      def check_custom(m, user)
        return if check_ignore(m.user)

        reload
        if @storage.key?(user)
          if @storage[user].key? 'wLocation'

            coords = @storage[user]['wLocation']

            address = @storage[user]['wAddress']

            locale = address

            data = get_current(coords, locale, false) # Again, we don't want locale printed, especially with this function

            return m.reply 'On no! There was a problem fetching the specified weather data for this user. Please try again later!.' if data.nil?

            return m.reply(data)
          end
        end
        m.reply 'This user has no custom data set.'
      end

      def custom_h(m, hour)
        return if check_ignore(m.user)

        reload
        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'wLocation'

            coords = @storage[m.user.nick]['wLocation']

            address = @storage[m.user.nick]['wAddress']

            locale = address

            data = get_hourly(hour, coords, locale, false)

            return m.reply 'Oh no! There was a problem fetching the specified weather data for your custom location! Please try again later.' if data.nil?

            return m.reply hourly_summary(data, hour)
          end
        end
        m.reply 'You have no custom data set. You can PM me with !set-l <location>'
      end

      def custom_d(m, day)
        return if check_ignore(m.user)

        reload
        if @storage.key?(m.user.nick)
          w_user = @storage[m.user.nick]
          if w_user.key? 'location_data'
            location_data = w_user['location_data']
            coords = location_data['coords']

            name = location_data['name']

            data = get_daily(day, name, locale, false)

            return m.reply 'Oh no! There was a problem fetching the specified weather data for your custom location! Please try again later.' if data.nil?

            return m.reply daily_summary(data, day)
          end
        end
        m.reply 'You have no custom data set. You can PM me with !set-l <location>'
      end

      def reload
        @storage = if File.exist?('docs/userinfo.yaml')
                     YAML.load_file('docs/userinfo.yaml')
                   else
                     {}
                   end
      end

      # Converts degrees to direction

      def getDirection(deg)
        deg = ((deg / 22.5) + 0.5).to_i
        directions = %w[N NNE NE ENE E ESE SE SSE
                        S SSW SW WSW W WNW NW NNW]
        directions[(deg % 16)]
      end

      # Fetch the current weather data for the location found in geolookup.

      def get_current(coords, locale, withLocale)
        key = config[:key]
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{coords}").read)
        current = data['currently']

        conditions = current['summary']
        temp           = current['temperature']
        feels_like     = current['apparentTemperature']
        wind_speed     = current['windSpeed']
        humidity       = current['humidity']
        wind_bearing   = current['windBearing']
        wind_direction = getDirection(wind_bearing.to_i)

        temp_c         = (temp - 32) * 5 / 9
        feels_temp_c   = (feels_like - 32) * 5 / 9
        wind_speed_kph = wind_speed * 1.6
        temp_c         = (temp_c * 10).ceil / 10.0
        feels_temp_c   = (feels_temp_c * 10).ceil / 10.0
        wind_speed_kph = (wind_speed_kph * 10).ceil / 10.0
        humidity *= 100
        humidity = format('%.2f', humidity)

        if withLocale
          return "10Weather: #{locale} | Current Weather: #{conditions} | Temp: #{temp} °F (#{temp_c} °C) - Feels like: #{feels_like} °F (#{feels_temp_c} °C) | Humidity: #{humidity}% | Wind: #{wind_speed} MPH (#{wind_speed_kph} KPH) - Bearing: #{wind_bearing} (#{wind_direction})"
        end

        "10Weather: Current Weather: #{conditions} | Temp: #{temp} °F (#{temp_c} °C) - Feels like: #{feels_like} °F (#{feels_temp_c} °C) | Humidity: #{humidity}% | Wind: #{wind_speed} MPH (#{wind_speed_kph} KPH) - Bearing: #{wind_bearing} (#{wind_direction})"
      rescue StandardError
        nil
      end

      def ifAlert(m, coords, locale)
        alerts = alert(coords, locale, true)
        return m.user.notice 'There are no alerts for this area.' if alerts.nil?

        if check_auth(m.user)
          m.user.notice alert(coords, locale, true)
          return
        end
        unless check_auth(m.user)
          m.user.notice alert(coords, locale, false)
          return
        end
      end

      def alert(coords, _locale, authed)
        key = config[:key]
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{coords}").read)
        warning = data['alerts'][0]

        title = warning['title']
        time = warning['time']
        expires = warning['expires']
        content = warning['description']
        url = warning['uri']

        time = Time.at(time.to_i)
        expires = Time.at(expires.to_i)

        content.tr! "\n", ' '

        content = content[0..200]

        url = Cinch::Toolbox.shorten(url)

        if authed
          return "WEATHER ALERT || #{title}: #{content}... [Read More: #{url}] || Time: #{time} - Expires: #{expires}"
        end

        "\u00034\u0002THERE IS A WEATHER ALERT IN THIS AREA, PLEASE AUTH WITH NICKSERV AND TRIGGER AGAIN TO READ."
      rescue StandardError
        nil
      end

      # Now we are going to fetch the hourly data.

      def get_hourly(hour, coords, locale, withLocale)
        key = config[:key]
        logo = "\u0002\u000310Hourly Fore\u000F\u0002\u00034cast\u000F:"
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{coords}").read)
        raw_hourly = data['hourly']['data']
        hourly = []
        raw_hourly.each do |i|
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

          if withLocale
            hourly.push(format("%s - #{locale}: Forecast Predicted in #{hour} hour(s): %s | Temp: [ %s °F (%s °C) | Will feel like: %s °F (%s °C) ] | Wind: [ Speed: %s MPH (%s KPH) | Bearing: %s ]", logo, sum, temp, temp_c, feels_temp, feels_temp_c, wind, wind_speed_kph, bear))
          else
            hourly.push(format("%s - Forecast Predicted in #{hour} hour(s): %s | Temp: [ %s °F (%s °C) | Will feel like: %s °F (%s °C) ] | Wind: [ Speed: %s MPH (%s KPH) | Bearing: %s ]", logo, sum, temp, temp_c, feels_temp, feels_temp_c, wind, wind_speed_kph, bear))
          end
        end
        hourly
      end

      def hourly_summary(data, hour)
        data[hour.to_i - 1]
      end

      # Now we are going to fetch the daily data.

      def get_daily(day, coords, locale, withLocale)
        key = config[:key]
        logo = "\u0002\u000310Daily Fore\u000F\u0002\u00034cast\u000F:"
        data = JSON.parse(open("https://api.forecast.io/forecast/#{key}/#{coords}").read)
        raw_daily = data['daily']['data']
        daily = []
        raw_daily.each do |i|
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

          if withLocale
            daily.push(format("%s - #{locale}: Forecast Predicted in #{day} day(s): %s | Temp: [ 10Low: %s °F (10#{temp_c_min} °C) | 4High: %s °F (4#{temp_c_max} °C) ] - Will Feel Like: [ 10Low: %s °F (10#{feels_temp_c_min} °C) | 4High: %s °F (4#{feels_temp_c_max} °C) ] | Wind: [ Speed: %s MPH (#{wind_speed_kph} KPH) | Bearing: %s ]", logo, sum, min, max, appmin, appmax, wind, bear))
          else
            daily.push(format("%s - Forecast Predicted in #{day} day(s): %s | Temp: [ 10Low: %s °F (10#{temp_c_min} °C) | 4High: %s °F (4#{temp_c_max} °C) ] - Will Feel Like: [ 10Low: %s °F (10#{feels_temp_c_min} °C) | 4High: %s °F (4#{feels_temp_c_max} °C) ] | Wind: [ Speed: %s MPH (#{wind_speed_kph} KPH) | Bearing: %s ]", logo, sum, min, max, appmin, appmax, wind, bear))
          end
        end
        daily
      end

      def daily_summary(data, day)
        data[day.to_i - 1]
      end
    end
  end
end
