require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class Die
    include Cinch::Plugin
    include Cinch::Helpers
	
    set plugin_name: 'Die'
    set help: '~die - Commands the bot to kill the process'

    match /die/
	
	def execute(m)
	  if m.channel
	    unless check_user(m.user)
          m.reply Format(:red, "You are not authorized to use this command!")
        return;
	  end
	    bot.info("Received valid quit command from #{m.user.nick}")
      m.reply Format(:green, "Very well. Goodbye.")
      bot.quit("on command of #{m.user.nick}")
    end
  end
end
end