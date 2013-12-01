require 'cinch'
# require 'cinch/plugins/twitter'
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
require_relative "lib/eve/plugins/privchancp"
require_relative "lib/eve/plugins/privatecp"

# In the block below make sure to enter your server information as well as
# the channels that you want it to join. Don't be lazy!

bot = Cinch::Bot.new do
  configure do |c|
  c.server = "rawr.coreirc.org"
  c.channels = ["#Eve"]
  c.nick = "Eve"
  c.user = "Eve"
  c.realname = "Eve 1.0"
  c.plugins.plugins = [Cinch::Plugins::Google,
    Cinch::Plugins::UrbanDictionary,
    Cinch::Plugins::Help,
    Cinch::Plugins::Seen,
   # Cinch::Plugins::Twitter,
    Cinch::Plugins::Greeting,
    Cinch::Plugins::Eightball,
    Cinch::Plugins::Decide,
    Cinch::Plugins::Memo,
    Cinch::Plugins::AIRespond,
    Cinch::Plugins::ControlPanel,
    Cinch::Plugins::ChanopCP,
    Cinch::Plugins::PrivateCP,
    Cinch::Plugins::PrivChanCP];
   # In order to make the Twitter plugin work you need to get the api keys
   # from twitter.com. When you have done that and put in the proper keys
   # you can un-comment Cinch::Plugins::Twitter, and the block below, as
   # well as the twitter require line above!
   # c.plugins.options[Cinch::Plugins::Twitter] = {
   # access_keys: {
   # consumer_key: "key",
   # consumer_secret: "key",
   # oauth_token: "key",
   # oauth_token_secret: "key"
   #   }
   # }
    c.password = "nspass"
  end
  
  on :action, "kicks the bot" do |m|
  m.reply "Ouch! Stop kicking me :("
  m.reply "I thought you loved me D:", true
end
end

bot.start