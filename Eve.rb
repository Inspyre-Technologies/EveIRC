require 'cinch'
require 'cinch/plugins/twitter'
require 'redis'
require_relative "lib/eve/plugins/google"
require_relative "lib/eve/plugins/urban_dictionary"
require_relative "lib/eve/plugins/help"
require_relative "lib/eve/plugins/seen"
require_relative "lib/eve/plugins/greeting"
require_relative "lib/eve/plugins/8ball"
require_relative "lib/eve/plugins/decide"
require_relative "lib/eve/plugins/memo"
require_relative "lib/eve/plugins/ai"
require_relative "lib/eve/plugins/controlpanel"
require_relative "lib/eve/plugins/chanopcp"


bot = Cinch::Bot.new do
  configure do |c|
  c.server = "rawr.coreirc.org"
  c.channels = ["#Eve"]
	c.nick = "Eve"
	c.user = "Eve"
	c.realname = "Eve 1.RC"
  c.plugins.plugins = [Cinch::Plugins::Google,
	Cinch::Plugins::UrbanDictionary,
	Cinch::Plugins::Help,
	Cinch::Plugins::Seen,
	Cinch::Plugins::Twitter,
	Cinch::Plugins::Greeting,
	Cinch::Plugins::Eightball,
	Cinch::Plugins::Decide,
	Cinch::Plugins::Memo,
  Cinch::Plugins::AIRespond,
  Cinch::Plugins::ControlPanel,
  Cinch::Plugins::ChanopCP];
	c.plugins.options[Cinch::Plugins::Twitter] = { 
    access_keys: { 
    consumer_key: "key", 
    consumer_secret: "key", 
    oauth_token: "key", 
    oauth_token_secret: "key" 
  } 
}
    c.password = "nspass"
  end
  
  on :action, "kicks the bot" do |m|
  m.reply "Ouch! Stop kicking me :("
  m.reply "I thought you loved me D:", true
end
end

bot.start