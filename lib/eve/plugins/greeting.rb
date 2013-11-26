	

    require 'cinch'
     
    module Cinch::Plugins
      class Greeting
        include Cinch::Plugin
     
        def greet(m)
          [
            "Oh look it's #{m.user.nick} again. Lovely.",
            "Hello #{m.user.nick}! Welcome to #{m.channel}!",
            "So yeah, that #{m.user.nick} I really can't st- OH HI #{m.user.nick}!",
            "We weren't JUST talking about you, #{m.user.nick}",
            "#{m.user.nick}, where's my money?",
            "Hi #{m.user.nick}!",
            "Get out of here #{m.user.nick}, you don't want any part of this!",
            "Did you guys hear that? Oh it's just wind between #{m.user.nick}'s ears.",
            "#{m.user.nick}!!! Oh how I've missed you!",
            "...and I said 'I DIDN'T BRING THE BONG' XDDD, oh hi #{m.user.nick}",
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