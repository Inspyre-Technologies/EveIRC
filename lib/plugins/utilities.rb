module Cinch::Plugins
  class Utilities
    include Cinch::Plugin

    def deliver(m, result)
      m.reply result
    end


    def convert(m, query, unit)
      require 'ruby-units'

      result = Unit.new(query).convert_to(unit)
      deliver(m, result)

      0

    end


    def c_to_f(m, query)

      query  = query.to_i
      result = query * 9 / 5 + 32
      result = result.to_s + '°F'
      deliver(m, result)

    end

    def f_to_c(m, query)
      query  = query.to_i
      result = (query - 32) * 5 / 9
      result = result.to_s + '°C'
      deliver(m, result)
    end


    match /temp-to-f (.+)/i, method: :c_to_f

    match /temp-to-c (.+)/i, method: :f_to_c

  end
end
