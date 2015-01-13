require_relative 'config/settings/plugins.rb'
require 'cinch'
require 'active_support'
require_relative "config/admin_handler"
require_relative "config/plugin_handler"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.sinsira.net"
    c.channels = [
                  "#Eve"
                 ]
    c.nick = "Eve"
    c.user = "Eve"
    c.realname = "Eve 7"
    c.password = "foo"
    c.encoding = "UTF-8"
    f = open("config/settings/constants.rb")
    c.plugins.plugins = []
                        f.each_line {|line|
                                     line = Object.const_get(line.chomp)
                                     c.plugins.plugins.push line
                                    
                                    }
  end
end

bot.start
