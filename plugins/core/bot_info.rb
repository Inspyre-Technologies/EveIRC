require 'cinch'

module Cinch
  module Plugins
    class BotInfo
      include Cinch::Plugin
      
      set :plugin_name, "botinfo"
      set :help, <<-USAGE.gsub(/^ {6}/, '')
The BotInfo plugin can be used to get more information about me.
Usage:
* !info: This will deliver an extensive list of information to you about me.
USAGE
      
      match "info"

      def execute(m)

        r_version      = RUBY_VERSION
        r_platform     = RUBY_PLATFORM
        r_release      = RUBY_RELEASE_DATE
        b_version      = @bot.realname
        channels      = @bot.channels.sort.join(', ')
        channels_count = @bot.channels.length
        name          = @bot.nick
        plugin_count   = @bot.plugins.count
        cinch_version  = Cinch::VERSION
        users         = proc {
          users = [];
        @bot.channels.each {|c|
                            c.users.each {|u| users << u[0].nick
                                          }
                           };
        users.uniq.size
        }.call

        m.user.send "Hello #{m.user.nick},"
        m.user.send "My name is #{name} running #{b_version}!"
        m.user.send "I use the Cinch Framework, my current Cinch version is #{cinch_version}!"
        m.user.send "I am running #{plugin_count} plugins!"
        m.user.send "I am on #{channels_count} channels: #{channels}. Serving #{users} users!"
        m.user.send "I am programmed in Ruby. My current Ruby version is #{r_version} released #{r_release}, using #{r_platform}."
      end
    end
  end
end