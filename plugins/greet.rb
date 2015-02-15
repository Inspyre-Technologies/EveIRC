require 'cinch'
require_relative '../lib/helpers/logger'

module Cinch
  module Plugins
    class Greet
      include Cinch::Plugin
      include Cinch::Helpers
      
      PluginName = "Greet"
      
      def initialize(*args)
        super
        if File.exist?('config/settings/user_info.yaml')
          log_message("message", "Loading user_info.yaml...", PluginName)
          user_settings = YAML.load_file('config/settings/user_info.yaml')
          log_message("message", "user_info.yaml loaded successfully!", PluginName)
          log_message("message", "Creating array from user_info.yaml contents", PluginName)
          @userNicks = user_settings
          log_message("message", "Array created!", PluginName)
        else
          log_message("warn", "No user_info.yaml file found. Continuing without it...", PluginName)         
        end
      end
      
      listen_to :join, :method => :greet
      
      def greet(m)
        reload
        if @userNicks.key?(m.user.nick.downcase) and @userNicks[m.user.nick.downcase].key?('greeting')
          greeting = @userNicks[m.user.nick.downcase]['greeting']
          m.reply "#{greeting}"
        else
          m.reply "Hello, #{m.user.nick}!"
        end
      end
      
      def reload
        @userNicks = YAML.load_file('config/settings/user_info.yaml')
      end
      
    end
  end
end
