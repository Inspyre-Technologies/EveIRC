require 'cinch'
     
module Cinch::Plugins
  class Greeting
    include Cinch::Plugin
     
    def greet(m)
      [
        Format(:green, "Hi #{m.user.nick}!"),
        Format(:green, "Hello #{m.user.nick}! Welcome to #{m.channel}!"),
        Format(:green, "#{m.user.nick}, I love you!"),
        Format(:green, "Hi #{m.user.nick}, I want to hold your hand!"),
        Format(:green, "#{m.user.nick}, where's my money?"),
        Format(:green, "Ladies and gentlemen! #{m.user.nick} is here!"),
        Format(:green, "#{m.user.nick}, how are ya?"),
        Format(:green, "Oh hi there, #{m.user.nick}."),
        Format(:green, "#{m.user.nick}!!! Oh how I've missed you!"),
        Format(:green, "Welcome to #{m.channel}, #{m.user.nick}."),
        Format(:green, "Oh it's #{m.user.nick}, look what the cat dragged in.")
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
        Format(:green, "Stop! In the name of love!")
      ].sample
    end
		
      listen_to :join, :method => :hello
      listen_to :leaving, :method => :goodbye
    
    def hello(m)
      unless m.user.nick == bot.nick
        m.reply greet(m)
      return;
    end
        m.reply botgreet(m)
    end
     
    def goodbye(m)
		  unless m.user == bot
        m.channel.send leave(m)
      return;
    end
  end
end
end