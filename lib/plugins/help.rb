# Author: Richard Banks
# E-Mail: namaste@rawrnet.net

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

    set :prefix, /^~/
    match "help"



    def execute(m)
      list = @bot.plugins.map {|p| p.class.plugin_name}
      list = list.sort.join(', ')
      m.user.send Format(:green, "Hello, #{m.user.nick}")
      m.user.send Format(:green, "The following is a list of plugins for #{@bot.realname}! To get usage information on a plugin just type ~help <plugin name>")
      m.user.send Format(:orange, "#{list}")
      return;
    end
  end
end
