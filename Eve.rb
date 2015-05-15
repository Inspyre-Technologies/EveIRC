require 'cinch'
require 'yaml'
require 'active_support'
require_relative 'lib/utils/config_checks'
require_relative 'lib/helpers/file_handler'

$eve_version = "7.0"

if $settings_file.nil?
  botnick = "Eve"
else
  botnick = $settings_file['nick'].to_s
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.catiechat.net"
    c.channels = [
                  "#Eve"
                 ]
    c.nick = "#{botnick}"
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
