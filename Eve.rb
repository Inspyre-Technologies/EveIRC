require 'cinch'
require 'yaml'
require 'active_support'
require_relative 'lib/utils/config_checks'
require_relative 'lib/helpers/file_handler'

$eve_version = "7.0alpha2.1.0"

# Find out of there is a config file, if
# there is a config file then it pulls
# the IRC server from the settings file.
# Otherwise, the bot will default to it's
# home server of Sinsira.

if $settings_file.nil?
  irc_server  = "irc.sinsira.net"
  server_port = "6667"
  server_ssl  = "false"
  ssl_verify  = "false"
  botnick     = "Eve"
else
  irc_server  = $settings_file['irc_server'].to_s
  server_port = $settings_file['server_port'].to_s
  server_ssl  = $settings_file['server_ssl'].to_s
  ssl_verify  = $settings_file['ssl_verify'].to_s
  botnick     = $settings_file['nick']
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server          = "#{irc_server}"
    c.port            = "#{server_port}"
    c.ssl.use         = server_ssl
    c.ssl.verify      = false
    c.channels        = [
                         "#Eve"
                        ]
    c.nick            = "#{botnick}"
    c.user            = "Eve"
    c.realname        = "Eve #{$eve_version}"
    c.encoding        = "UTF-8"
    f                 = open("config/settings/constants.rb")
    c.plugins.plugins = []
                        f.each_line {|line|
                                     line = Object.const_get(line.chomp)
                                     c.plugins.plugins.push line

                                    }
  end
end

bot.start
