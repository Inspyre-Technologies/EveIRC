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
require_relative "lib/eve/plugins/actai"
require_relative "lib/eve/plugins/factcore"


# You should have something in the block below as it will have Eve report
# invalid or unauthorized use of her commands to the nicks you place in it
# Note: Please keep in mind that this doesn't check if the dispatch nick 
# is authed so if for some reason it is imperative that no one but the bot
# masters see output maybe it is wise to only put your nick in here and 
# make sure no one steals it!

Config = OpenStruct.new

Config.dispatch = ["foo", "bar", "you"]

# In the block below make sure to enter your server information as well as
# the channels that you want it to join. Don't be lazy!

bot = Cinch::Bot.new do
  configure do |c|
  c.server = "rawr.coreirc.org"
  c.channels = ["#Eve"]
  c.nick = "Eve"
  c.user = "Eve"
  c.realname = "Eve 1.4"
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
    Cinch::Plugins::PrivChanCP,
    Cinch::Plugins::ActAI,
    Cinch::Plugins::FactCore];
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
end

bot.start