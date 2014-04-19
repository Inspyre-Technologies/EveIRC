require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'cgi'

module Cinch
  module Plugins
    class Isitup
      include Cinch::Plugin
      
      set :plugin_name, 'isitup'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
Is it just you, or is your favorite website down? Find out!
Usage:
* !isitup <url>: Checks to see if the given website is up or not.
USAGE
      
      match /isitup (.+)/
      
      def execute(m, query)
        return if check_ignore(m.user)
        data = check(query)
        return m.reply "There seems to be an issue, please contact my Master." if data.nil?
        isitup_result(m, data)
      end
      
      def check(terms)
        data = JSON.parse(open("http://isitup.org/#{terms}.json").read)
         OpenStruct.new(
           domain:  data['domain'],
           status:  data['status_code'],
           time:    data['response_time']
        )
      rescue
        nil
      end
      
      def isitup_result(m, data)
        if data.status == 3
          m.reply Format(:red, "That is not a valid domain!")
        return;
      end
        if data.status == 2
          m.reply "4The domain:13 #{data.domain}4 is down!"
        return;
      end
        if data.status == 1
          m.reply "3The domain: 13#{data.domain}3 is up! Response time:  13#{data.time}."
        return;
      end
    end
  end
end
end
