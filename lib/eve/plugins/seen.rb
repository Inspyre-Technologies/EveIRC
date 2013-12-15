require 'cinch'

module Cinch::Plugins
  class Seen
  class SeenStruct < Struct.new(:who, :where, :what, :time)
    
    def to_s
      "[#{time.asctime}] #{who} was seen in #{where} saying #{what}"
    end
  end
    
    # This plugin was not written by me and frankly I believe it to be
    # outdated. I will soon re-write a plugin that does that same but is
    # persistent with the data.
    
    include Cinch::Plugin
    listen_to :channel
    
    set :plugin_name, 'seen'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      The seen plugin is great for finding out when the last time a user spoke in a channel I am in!
      Usage:
      - !seen <nick>: This will cause the bot to return with the last instance of this user speaking in a channel it was in.
    USAGE
  
    match /seen (.+)/

    def initialize(*args)
      super
        @users = {}
      end

    def listen(m)
      @users[m.user.nick] = SeenStruct.new(m.user, m.channel, m.message, Time.now)
    end

    def execute(m, nick)
        if nick == @bot.nick
          m.reply "That's me!"
        elsif nick == m.user.nick
          m.reply "That's you!"
        elsif @users.key?(nick)
          m.reply @users[nick].to_s
        else
          m.reply "I haven't seen #{nick}"
        end
      end
    end
  end

# EVE is a project for a Top-Tier IRC bot, and the project could always use more help.
# Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at irc.catiechat.net