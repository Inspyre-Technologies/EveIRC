module Cinch::Plugins
  class Utilities
    include Cinch::Plugin

    set :plugin_name, 'utilities'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
    This plugin has one function for now; the conversion of temperature readings from Fahrenheit to Celsius or vice-versa 
    Usage:
    - !temp-to-f <INTEGER>: Will convert <INTEGER> into degrees in Fahrenheit
    - !temp-to-c <INTEGER>: Will convert <INTEGER> into degrees in Celsius
    USAGE

    def deliver(m, result, query)
      ans = "#{query} -> #{result}"
      m.reply ans, true
    end

    def c_to_f(m, query)

      query  = query.to_i
      result = query * 9 / 5 + 32
      result = result.to_s + '°F'
      query  = query.to_s + '°C'
      deliver(m, result, query)

    end

    def f_to_c(m, query)
      query  = query.to_i
      result = (query - 32) * 5 / 9
      result = result.to_s + '°C'
      query  = query.to_s + '°F'
      deliver(m, result, query)
    end


    match /temp-to-f (.+)/i, method: :c_to_f

    match /temp-to-c (.+)/i, method: :f_to_c

  end
end
