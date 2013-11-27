require 'cinch'
     
module Cinch::Plugins
  class Greeting
    include Cinch::Plugin
     
    def greet(m)
      [
        "Hi #{m.user.nick}!",
        "Hello #{m.user.nick}! Welcome to #{m.channel}!",
        "#{m.user.nick}, I love you!",
        "Hi #{m.user.nick}, I want to hold your hand!",
        "#{m.user.nick}, where's my money?",
        "Ladies and gentlemen! #{m.user.nick} is here!",
        "#{m.user.nick}, how are ya?",
        "Oh hi there, #{m.user.nick}.",
        "#{m.user.nick}!!! Oh how I've missed you!",
        "Welcome to #{m.channel}, #{m.user.nick}.",
        "Oh it's #{m.user.nick}, look what the cat dragged in."
      ].sample
    end
		
    def leave(m)
      [
        "Well fine then #{m.user.nick}, we didn't want to talk to you anyway",
        "Goodbye #{m.user.nick}, we're gonna miss you!",
        "Okay #{m.user.nick} is gone now, can we party?",
        "Phew I thought #{m.user.nick} would never leave!",
        "Are you kidding me? #{m.user.nick} was about to give me the answer to life, the universe, and everything!",
        ";-; WHY!? WHY!? WHY DID #{m.user.nick} HAVE TO GO!?",
        "#{m.user.nick}? Why did you leave?",
        "#{m.user.nick} there you go with my heart again."
      ].sample
    end
		
    listen_to :join, :method => :hello
    listen_to :part, :method => :goodbye
    listen_to :quit, :method => :goodbye
    
    def hello(m)
      unless m.user.nick == bot.nick
        m.reply greet(m)
      return;
    end
        m.reply Format(:green, "Hello #{m.channel}! Systems online!")
    end
     
    def goodbye(m)
		  unless m.user == bot
        m.channel.send leave(m)
      return;
    end
  end
end
end