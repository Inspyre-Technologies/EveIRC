require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class Help
  include Cinch::Plugin
  include Cinch::Helpers

  match "help"
  
  def execute(m)
    if m.channel
	  unless check_user(m.user)
	    m.user.send Format(:green, "Hello, #{m.user.nick}")
        m.user.send Format(:green, "As of now I don't have many commands that you can choose from. Since I am in Beta mode :(")
		m.user.send Format(:green, "However, please enjoy the following commands at your leisure: Please remember that the prefix is ~, example ~help")
		m.user.send Format(:green, "%s | This searches Google and returns the #1 search result!" % [Format(:red, "google <search terms>")])
		m.user.send Format(:green, "%s | This searches Urban Dictionary and returns the definition" % [Format(:red, "urban <search terms>")])
		m.user.send Format(:green, "%s | Searches for the last time I saw a nick active in a channel I was in." % [Format(:red, "seen <usernick>")])
		m.user.send Format(:green, "%s | Retrieves the latest Tweet from the given user. Add integers up to 20 to retrieve earlier tweets! Do not use ~ use @" % [Format(:red, "@<twitter-handle>")])
		m.user.send Format(:green, "%s | Retrieves a quote from the database created for this network." % [Format(:red, "quote")])
		m.user.send Format(:green, "%s | Adds a quote to the database created for this network." % [Format(:red, "addquote")]) 
		m.user.send Format(:green, "%s | Just like the 8Ball you had as a kid!" % [Format(:red, "8ball <question>")])
		m.user.send Format(:green, "%s | You give me two or more options and I will decide for you!" % [Format(:red, "decide <option1, option2>")])
		m.user.send Format(:green, "%s | Just a coinflip. Heads or tails!" % [Format(:red, "coin")])
		m.user.send Format(:green, "%s | It is recommended you use this in a PM. It will send your message to the specified user when they speak next in a channel I am in! The message will be delivered via PM" % [Format(:red, "memo <nick> <message>")])
	  return;
	end
	  m.user.send Format(:green, "Hello, #{m.user.nick}")
	  m.user.send Format(:green, "As of now I don't have many commands that you can choose from. Since I am in Beta mode :(")
	  m.user.send Format(:green, "However, please enjoy the following commands at your leisure:")
	  m.user.send Format(:green, "%s | This searches Google and returns the #1 search result!" % [Format(:red, "google <search terms>")])
	  m.user.send Format(:green, "%s | This searches Urban Dictionary and returns the definition" % [Format(:red, "urban <search terms>")])
	  m.user.send Format(:green, "%s | Searches for the last time I saw a nick active in a channel I was in." % [Format(:red, "seen <usernick>")])
	  m.user.send Format(:green, "%s | Retrieves the latest Tweet from the given user. Add integers up to 20 to retrieve earlier tweets!Do not use ~ use @ " % [Format(:red, "@<twitter-handle>")])
	  m.user.send Format(:green, "%s | Just like the 8Ball you had as a kid!" % [Format(:red, "8ball <question>")])
      m.user.send Format(:green, "%s | You give me two or more options and I will decide for you!" % [Format(:red, "decide <option1, option2>")])
      m.user.send Format(:green, "%s | Just a coinflip. Heads or tails!" % [Format(:red, "coin")])
	  m.user.send Format(:green, "%s | It is recommended you use this in a PM. It will send your message to the specified user when they speak next in a channel I am in! The message will be delivered via PM" % [Format(:red, "memo <nick> <message>")])
	  m.user.send Format(:red, "The following commands are only available to operators of the bot! USE WITH CAUTION!! USE OF EVERY ONE OF THESE COMMANDS IS REPORTED!!!")
	  m.user.send Format(:green, "%s | Makes the bot give you +o in a channel." % [Format(:red, "opme")])
	  m.user.send Format(:green, "%s | Kill the bot process. You will not be able to bring it back online without shell access!" % [Format(:red, "die")])
	  m.user.send Format(:green, "%s | Makes the bot join the specified channel." % [Format(:red, "join <#channel>")])
      m.user.send Format(:green, "%s | Makes the bot part the current channel." % [Format(:red, "part")])
	  m.user.send Format(:green, "%s | THIS MUST BE USED IN A PM WITH THE BOT. It will send a specified message to a channel if it's in it." % [Format(:red, ".say <channel> <message>")])
	end
   end
 end
end