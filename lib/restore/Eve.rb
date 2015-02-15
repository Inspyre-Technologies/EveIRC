require 'cinch'
require 'active_support'
require_relative 'lib/utils/config_checks'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.catiechat.net"
    c.channels = [
                  "#Eve"
                 ]
    c.nick = "eveSeven"
    c.user = "Eve"
    c.realname = "Eve 7"
    c.password = "b0xxy5476"
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
