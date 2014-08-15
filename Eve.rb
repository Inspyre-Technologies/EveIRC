require 'cinch'
## The file referenced below should be gone over to make sure that you
## want to load the plugins listed.
require_relative "bin/plugins"


# You should have something in the block below as it will have Eve report
# invalid or unauthorized use of her commands to the nicks you place in it
# Note: Please keep in mind that this doesn't check if the dispatch nick
# is authed so if for some reason it is imperative that no one but the bot
# masters see output maybe it is wise to only put your nick in here and
# make sure no one steals it!

Config = OpenStruct.new

Config.dispatch = ["foo", "bar", "you"]

Config.owner = ["Namaste"]

# In the block below make sure to enter your server information as well as
# the channels that you want it to join. Don't be lazy!

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.sinsira.net"
    c.channels = ["#Eve"]
    c.nick = "Eve"
    c.user = "Eve"
    c.realname = "Eve 6.4"

    ## Below is the plugin block for Eve-Bot. Please be sure that all the plugins
    ## that you want the bot to use are included in this block. If you want to
    ## remove a plugin from Eve-Bot simply remove it's entry from this block
    ## (including the trailing colon), and take note of it's format! If you've
    ## removed a plugin and the bot won't start it's probably because you removed,
    ## added, or transposed a colon or semicolon, or you didn't delete the options
    ## for the plugin, located below in the options block.

    c.plugins.plugins = [Cinch::Plugins::PluginManagement,
                         Cinch::Plugins::Urban,
                         Cinch::Plugins::Help,
                         Cinch::Plugins::Seen,
                         Cinch::Plugins::Greeting,
                         Cinch::Plugins::Eightball,
                         Cinch::Plugins::Decide,
                         Cinch::Plugins::Memo,
                         Cinch::Plugins::Ai,
                         Cinch::Plugins::ControlPanel,
                         Cinch::Plugins::ChanopCP,
                         Cinch::Plugins::PrivateCP,
                         Cinch::Plugins::PrivChanCP,
                         Cinch::Plugins::FactCore,
                         Cinch::Plugins::ActAI,
                         Cinch::Plugins::UrlScraper,
                         Cinch::Plugins::Twitter,
                         Cinch::Plugins::TwitterStatus,
                         Cinch::Plugins::Wikipedia,
                         Cinch::Plugins::Weather,
                         Cinch::Plugins::Google,
                         Cinch::Plugins::YouTube,
                         Cinch::Plugins::Math,
                         Cinch::Plugins::UserInfo,
                         Cinch::Plugins::Isitup,
                         Cinch::Plugins::RelationshipHandler,
                         Cinch::Plugins::IgnoreHandler,
                         Cinch::Plugins::AdminHandler,
                         Cinch::Plugins::FourChan,
                         Cinch::Plugins::Dictionary,
                         Cinch::Plugins::News],
                         Cinch::Plugins::Wolfram,
                         Cinch::Plugins::CoinQuery,
                         Cinch::Plugins::WordGame,
                         Cinch::Plugins::Reddit,
                         Cinch::Plugins::Tag];

    ## Below this line MUST be configured for the bot to work. That means DO NOT
    ## skip over these options or the bot WILL NOT WORK. If you do not want the
    ## plugins to work for whatever reason then do not igore these plugin options,
    ## instead, delete them from this file, and the above plugin block.

    c.plugins.options[Cinch::Plugins::UrlScraper] = { enabled_channels: ["#foo", "#bar" "#channel"] }

    c.plugins.options[Cinch::Plugins::Greeting] = { enabled_channels: ["#foo", "#bar" "#channel"] }

    c.plugins.options[Cinch::Plugins::TwitterStatus] = { consumer_key:    'foo',
                                                         consumer_secret: 'foo',
                                                         access_token:     'foo',
                                                         access_token_secret:    'foo',
                                                         watchers:        { '#foo' => ['bar'] }
                                                       }

    c.plugins.options[Cinch::Plugins::Twitter] = { access_keys: {
                                                                 consumer_key: "foo",
                                                                 consumer_secret: "foo",
                                                                 access_token: "foo",
                                                                 access_token_secret: "foo"
                                                                }
                                                 }

    c.plugins.options[Cinch::Plugins::Wolfram] = { key: 'foo' }

    c.plugins.options[Cinch::Plugins::Weather] = { key: 'foo' }

    c.password = "nspass"

  end
end

bot.start
