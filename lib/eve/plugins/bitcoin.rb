require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'

module Cinch
  module Plugins
    class Bitcoin
      include Cinch::Plugin
      
      set :plugin_name, 'bitcoin'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Just a seen plugin!
          Usage:
            * !btcv: Returns the latest value of 1 (one) Bitcoin in USD
          USAGE
      
      match /btcv/
      
      def execute(m)
        data = JSON.parse(open("http://blockchain.info/ticker").read)
        value = data['USD']['15m']
        m.reply "Current value of 1 BTC in USD is: #{value}", true
      end
    end
  end
end