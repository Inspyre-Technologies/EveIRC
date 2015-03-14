# Author: Richard Banks
# E-Mail: namaste@rawrnet.net
# determine_name.rb: This is a helper to determine
# a triggering user's name. This can be used to 
# decide whether or not the bot calls the user by
# their IRC nickname or a stored name.
require_relative 'logger'
require 'yaml'

module Cinch
  module Helpers
    
    def determine_name(m)
      @userSettings = YAML.load_file('config/settings/user_info.yaml')
      irc_nick = User(m.user).nick
      if @userSettings.key?(irc_nick.downcase) 
        if @userSettings[irc_nick.downcase].key?('irl_name')
          if @userSettings[irc_nick.downcase]['irl_name'] != false
            irl_nick = @userSettings[irc_nick.downcase]['irl_name']
            nick_array = ["#{irl_nick}", "#{irc_nick}"]
            return nick_array.sample
          else
            return irc_nick
          end
        else
          return irc_nick
        end
      else
        return irc_nick
      end
    end
    
  end
end