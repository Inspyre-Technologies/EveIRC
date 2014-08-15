require 'cinch'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class BotInfo
      include Cinch::Plugin

      set :plugin_name, "botinfo"
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      You can use this plugin to get more information about me!
      Usage:
      * !info: I will give you information about myself.
      USAGE

      match "info"

      def execute(m)
        return if check_ignore(m.user)

        rVersion      = RUBY_VERSION
        rPlatform     = RUBY_PLATFORM
        rRelease      = RUBY_RELEASE_DATE
        bVersion      = @bot.realname
        channels      = @bot.channels.sort.join(', ')
        channelsCount = @bot.channels.length
        name          = @bot.nick
        pluginCount   = @bot.plugins.count
        cinchVersion  = Cinch::VERSION
        users         = proc {
          users = [];
        @bot.channels.each {|c|
                            c.users.each {|u| users << u[0].nick
                                          }
                           };
        users.uniq.size
        }.call

        m.user.send "Hello #{m.user.nick},"
        m.user.send "My name is #{name} running #{bVersion}!"
        m.user.send "I use the Cinch Framework, my current Cinch version is #{cinchVersion}!"
        m.user.send "I am running #{pluginCount} plugins!"
        m.user.send "I am on #{channelsCount} channels: #{channels}. Serving #{users} users!"
        m.user.send "I am programmed in Ruby. My current Ruby version is #{rVersion} released #{rRelease}, using #{rPlatform}."
      end
    end
  end
end



