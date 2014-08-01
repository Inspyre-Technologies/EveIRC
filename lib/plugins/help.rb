# Author: Richard Banks
# E-Mail: namaste@rawrnet.net

# This is the main help handler. It gives the users an idea of what commands they
# have to work with. It lists the plugins and instructs them to seek further help
# from the plugin itself if needed.

require 'cinch'
require_relative "config/check_ignore"
require_relative "config/check_master"

module Cinch::Plugins
  class Help
    include Cinch::Plugin

    match "help"

    def execute(m)
      return if check_ignore(m.user)

      list = @bot.plugins.map {|p| p.class.plugin_name}

      exList = ["ai",
                "actai",
                "help"
              ]

      mList  = ["controlpanel",
                "ignorehandler",
                "pluginmanagement",
                "privatecp",
                "privchancp",
                "relationshiphandler",
                "adminhandler"
              ]

      newList = list - exList - mList


      m.user.send Format(:green, "Hello, #{m.user.nick}")
      m.user.send Format(:green, "The following is a list of plugins for #{@bot.realname}! To get usage information on a plugin just type ~help <plugin name>")
      m.user.send Format(:orange, "#{newList.sort.join(", ")}")
      if check_master(m.user)
        m.user.send Format(:red, "The following commands are for Masters of the bot only! #{mList.sort.join(", ")}")
      end
    end
  end
end
