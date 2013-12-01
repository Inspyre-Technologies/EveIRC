require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class Help
    include Cinch::Plugin
    include Cinch::Helpers

    match "help"
  
  def execute(m)
    if m.channel
      unless check_user(m.user)
        m.user.send Format(:green, "Hello, #{m.user.nick}")
        m.user.send Format(:green, "As of now I don't have many plugins that you can choose from. Since I am in Beta mode :(")
        m.user.send Format(:green, "However, please enjoy the following plugins at your leisure. You can get further information on a plugin by typing !help <plugin name> IN A PM. Don't do it in a channel!!")
        m.user.send Format(:orange, "google, memo, seen, urban, eightball, decider")
      return;
    end
        m.user.send Format(:green, "Hello, #{m.user.nick}")
        m.user.send Format(:green, "As of now I don't have many plugins that you can choose from. Since I am in Beta mode :(")
        m.user.send Format(:green, "However, please enjoy the following plugins at your leisure. You can get further information on a plugin by typing !help <plugin name> IN A PM. Don't do it in a channel!!")
        m.user.send Format(:orange, "google, memo, seen, urban, eightball, decider")
        m.user.send Format(:red, "The following plugins are only available to operators of the bot! USE WITH CAUTION!! USE OF EVERY ONE OF THESE PLUGINS IS REPORTED!!!")
        m.user.send Format(:red, "channelcp, controlpanel, privatecp, privchancp")
      end
    end
  end
end