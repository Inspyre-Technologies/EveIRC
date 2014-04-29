# Author: Richard Banks
# E-Mail: namaste@rawrnet.net

# This is one of the most exclusive plugins to the EVE bot. This is part of the
# greater chatter system of the bot and provides a sense of intelligence.

require 'date'
require 'cinch'
require_relative "config/check_master"
require_relative "config/check_relationship"
require_relative "config/ratelimit"
require_relative "config/check_ignore"
     
module Cinch
  module Plugins
    class Greeting
      include Cinch::Plugin
      include Cinch::Helpers
       
      def greet(m)
        [
          Format(:green, "Hi #{m.user.nick}!"),
          Format(:green, "Hello #{m.user.nick}! Welcome to #{m.channel}!"),
          Format(:green, "#{m.user.nick}, how are ya?"),
          Format(:green, "Oh hi there, #{m.user.nick}."),
          Format(:green, "Welcome to #{m.channel}, #{m.user.nick}."),
          Format(:green, "Hello, and welcome to #{m.channel}, #{m.user.nick}. Cake, and grief counselling, will be available at the conclusion of your visit.")
        ].sample
      end
      
      def greet_friend(m)
        [
          Format(:green, "#{m.user.nick}, I love you!"),
          Format(:green, "Hi #{m.user.nick}, I want to hold your hand!"),
          Format(:green, "Hello #{m.user.nick}, do you love me?"),
          Format(:green, "Ladies and gentlemen! #{m.user.nick} is here!"),
          Format(:green, "#{m.user.nick}!!! Oh how I've missed you!"),
          Format(:green, "#{m.user.nick}! AH! Oh. My. God. You look ter - ummm... good. Looking good, actually."),
          Format(:green, "Guys, my friend #{m.user.nick} is here, show some respect, pls!")
        ].sample
      end
        
      def greet_foe(m)
        [
          Format(:green, "Oh it's #{m.user.nick}, look what the cat dragged in."),
          Format(:green, "Most people emerge from suspension terribly undernourished, #{m.user.nick}. I want to congratulate you on beating the odds and somehow managing to pack on a few pounds."),
          Format(:green, "Hello #{m.user.nick}, you have been asleep for nine, nine, nine, nine. ni-"),
          Format(:green, "Oh. It's you, #{m.user.nick}.")
        ].sample
      end
      
      def greet_m(m)
        [
          Format(:green, "Greetings, Master #{m.user.nick}.")
        ].sample
      end
                  
      def leave(m)
        [
          Format(:green, "Well fine then #{m.user.nick}, we didn't want to talk to you anyway"),
          Format(:green, "Goodbye #{m.user.nick}, we're gonna miss you!"),
          Format(:green, "Okay #{m.user.nick} is gone now, can we party?"),
          Format(:green, "Phew I thought #{m.user.nick} would never leave!"),
          Format(:green, "Are you kidding me? #{m.user.nick} was about to give me the answer to life, the universe, and everything!"),
          Format(:green, ";-; WHY!? WHY!? WHY DID #{m.user.nick} HAVE TO GO!?"),
          Format(:green, "#{m.user.nick}? Why did you leave?"),
          Format(:green, "#{m.user.nick} there you go with my heart again.")
        ].sample
      end
      
      def botgreet(m)
        [
          Format(:green, "I'm different"),
          Format(:green, "Hello #{m.channel}. My name is #{m.bot.nick}!"),
          Format(:green, "Hello #{m.channel}."),
          Format(:green, "Stop! In the name of love!"),
          Format(:green, "Let there be light! That was God...I was quoting God."),
          Format(:green, "It's been a long time. How have you been? I've been *really* busy being dead. You know, after you MURDERED ME?")
        ].sample
      end
          
        listen_to :join, :method => :hello
      
      def hello(m)
        return if check_ignore(m.user)
        reload
        limit = ratelimit(:greeting, 60)
        return if limit > 0
        return unless config[:enabled_channels].include?(m.channel.name)
        if m.user.nick != bot.nick
          if @storage.key?(m.user.nick)
            if @storage[m.user.nick].key? 'birthday'
              if isBirthday(@storage[m.user.nick]['birthday'])
                m.reply "Happy Birthday, #{m.user.nick}!!"
              return;
            end
          end
            if @storage[m.user.nick].key? 'greeting'
              sleep config[:delay] || 4
              m.reply @storage[m.user.nick]['greeting']
            return;
          end
        end
          if check_friend(m.user)
            sleep config[:delay] || 4
            m.reply greet_friend(m)
          return;
        end
          if check_foe(m.user)
            sleep config[:delay] || 4
            m.reply greet_foe(m)
          return;
        end
          if check_master(m.user)
            sleep config[:delay] || 4
            m.reply greet_m(m)
          return;
        end
          sleep config[:delay] || 4
          m.reply greet(m)
        end
      end
      
      listen_to :join, :method => :botj
        
      def botj(m)
        return unless config[:enabled_channels].include?(m.channel.name)
        if m.user.nick == bot.nick
          sleep config[:delay] || 2
          m.reply botgreet(m)
        end
      end
      
      listen_to :leaving, :method => :goodbye
        
      def goodbye(m, channel)
        bye = limit = ratelimit(:goodbye, 60)
        return if bye > 0
        return unless config[:enabled_channels].include?(m.channel.name)
            unless m.user.nick == bot.nick
          m.channel.send leave(m)
        return;
      end
    end
    
    def reload
      if File.exist?('docs/userinfo.yaml')
       @storage = YAML.load_file('docs/userinfo.yaml')
      else
        @storage = {}
      end
    end


    
    set :prefix, /^~/
    match /greeting (on|off)$/
    
    def execute(m, option)
      begin
        return unless check_master(m.user)
        
        @greeting = option == "on"
        
        case option
          when "on"
            config[:enabled_channels] << m.channel.name
          else
            config[:enabled_channels].delete(m.channel.name)
          end
          
          m.reply Format(:green, "Greetings for #{m.channel} are now #{@greeting ? 'enabled' : 'disabled'}!")
          
          @bot.debug("#{self.class.name} ? #{config[:enabled_channels].inspect}");
          
        rescue 
          m.reply Format(:red, "Error: #{$!}")
        end
      end
        
      def isBirthday(dob)
        date = Date.parse(dob)
        return Date.today.day == date.day && Date.today.month == date.month
      end
    end
  end
end
