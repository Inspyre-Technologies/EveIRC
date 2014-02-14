require 'cinch'
require 'yaml'

module Cinch
  module Plugins
    class UserInfo
      include Cinch::Plugin
      
      set :plugin_name, 'userinfo'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
Save certain data to the bot for convienence and sometimes privacy
Usage:
* !set-w <location>: Save your location to the bot for future use in calling weather.
USAGE
      
      def initialize(*args)
        super
          if File.exist?('userinfo.yaml')
            @storage = YAML.load_file('userinfo.yaml')
          else
            @storage = {}
          end
        end
        
      match /set-w (.+)/, method: :set_w
      
      def set_w(m, zc)
        zc.gsub! /\s/, '+'
        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['zipcode'] = zc
        m.reply "Updated your weather location to #{zc}!"
        update_store
      rescue 
        m.reply Format(:red, "Error: #{$!}")
      end
      
      def update_store
        synchronize(:update) do
        File.open('userinfo.yaml', 'w') do |fh|
        YAML.dump(@storage, fh)
      end
    end
  end
end
end
end