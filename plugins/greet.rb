require 'cinch'
require_relative '../lib/helpers/logger'
require_relative '../lib/helpers/file_handler'

module Cinch
  module Plugins
    class Greet
      include Cinch::Plugin
      include Cinch::Helpers

      Plugin_Name = "Greet"

      def initialize(*args)
        super
        if $user_file
          log_message("message", "user_info.yaml loaded successfully!", Plugin_Name)
        else
          log_message("warn", "No user_info.yaml file found. Continuing without it...", Plugin_Name)
        end
      end

      listen_to :join, :method => :greet

      def greet(m)
        return m.reply "Hello #{m.channel}!" if m.user.nick == bot.nick
        if !$user_file
          m.reply "Hello, #{m.user.nick}!"
        else
          if $user_file.key?(m.user.nick.downcase) and $user_file[m.user.nick.downcase].key?('greeting')
            greeting = $user_file[m.user.nick.downcase]['greeting']
            m.reply "#{greeting}"
          else
            m.reply "Hello, #{m.user.nick}!"
          end
        end
      end
    end
  end
end