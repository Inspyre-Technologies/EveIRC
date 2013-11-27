require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class OpMe
    include Cinch::Plugin
    include Cinch::Helpers
  
    match /opme/
  
    def execute(m)
      if m.channel
        unless check_user(m.user)
          m.reply Format(:red, "You are not authorized to use this command!")
        return;
      end
        bot.info("Received valid OpMe command from #{m.user.nick}")
        m.reply Format(:green, "Very well...")
        bot.irc.send ("MODE #{m.channel} +o #{m.user.nick}")
      end
    end
  end
end
