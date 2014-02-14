require 'cinch'
require 'cinch/toolbox'
require 'cinch-storage'
require 'cinch/cooldown'
require 'time-lord'

module Cinch
  module Plugins
    class Seen
      include Cinch::Plugin
    
      class Watch < Struct.new(:nick, :time, :message)
        def to_yaml
          { nick: nick, time: time, message: message }
        end
      end
      
      enforce_cooldown
      
      set :plugin_name, 'seen'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Just a seen plugin!
          Usage:
            * !seen <name>: Use this to see the last thing a nick said and where
          USAGE
      listen_to :channel
      
      match /seen ([^\s]+)\z/
      
    def initialize(*args)
      super
      @storage = CinchStorage.new(config[:filename] || 'seen.yml')
      @storage.data ||= {}
    end
    
    def listen(m)
      channel = m.channel.name
      nick = m.user.nick
      @storage.data[channel] ||= {}
      @storage.data[channel][nick.downcase] =
        Watch.new(nick, Time.now, m.message)
      @storage.synced_save(@bot)
    end
    
    def execute(m, nick)
      return if sent_via_pm?(m)
      unless m.user.nick.downcase == nick.downcase
        m.reply last_seen(m.channel.name, nick), true
      end
    end
    
    private

    def last_seen(channel, nick)
      @storage.data[channel] ||= {}
      activity = @storage.data[channel][nick.downcase]
      
      if activity.nil?
        "I haven't seen #{nick} before, sorry!"
      else
        "I last saw #{activity.nick} #{activity.time.ago.to_words} " +
        "saying '#{activity.message}'"
      end
    end
    
    def sent_via_pm?(m)
      return false unless m.channel.nil?
      m.reply 'You must use that command in the main channel.'
      true
    end
  end
end
end