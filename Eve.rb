require 'cinch'
require 'active_support'
require_relative 'lib/utils/config_checks'
require_relative 'plugins/admin_handler'
require_relative 'plugins/core/bot_info'

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
