# This is the main help handler. It gives the users an idea of what commands they
# have to work with. It lists the plugins and instructs them to seek further help
# from the plugin itself if needed.

require 'cinch'
require_relative "config/check_master"
require_relative "config/check_ignore"

module Cinch::Plugins
  class Help
    include Cinch::Plugin
    include Cinch::Helpers
    
    match "help"
  
  def execute(m)
    return if check_ignore(m.user)
    unless check_master(m.user)
      m.user.send Format(:green, "Hello, #{m.user.nick}")
      m.user.send Format(:green, "You can get further information on a plugin by typing !help <plugin name> IN A PM. Don't do it in a channel!!")
      m.user.send Format(:orange, "memo, seen, urban, eightball, decider, factcore, weather, twitter, valentineboxx, wikipedia, google, youtube, 4chan, math, isitup, bitcoin, userinfo, news, wolfram")
      return;
    end
    m.user.send Format(:green, "Hello, #{m.user.nick}")
    m.user.send Format(:green, "You can get further information on a plugin by typing !help <plugin name> IN A PM. Don't do it in a channel!!")
    m.user.send Format(:orange, "memo, seen, urban, eightball, decider, factcore, weather, twitter, valentineboxx, wikipedia, google, youtube, 4chan, math, isitup, bitcoin, userinfo, news, wolfram")
    m.user.send Format(:red, "The following plugins are only available to operators of the bot! USE WITH CAUTION!! USE OF EVERY ONE OF THESE PLUGINS IS REPORTED!!!")
    m.user.send Format(:red, "channelcp, controlpanel, privatecp, privchancp, urlscraper, pluginmanagement, adminhandler, relationshiphandler, ignorehandler")
  end
  end
end

## Written by Richard Banks for Eve-Bot "The Project for a Top-Tier IRC bot.
## E-mail: namaste@rawrnet.net
## Github: Namasteh
## Website: www.rawrnet.net
## IRC: irc.sinsira.net #Eve
## If you like this plugin please consider tipping me on gittip
