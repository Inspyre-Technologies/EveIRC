## In order to load a plugin into Eve-Bot you must add the file to be loaded
## here. Please bear in mind that if the plugin in not loaded in here with
## the proper file name your bot will output an exception "unintialized
## constant"

require 'redis'
require_relative "../lib/plugins/urban"
require_relative "../lib/plugins/help"
require_relative "../lib/plugins/seen"
require_relative "../lib/plugins/greeting"
require_relative "../lib/plugins/eightball"
require_relative "../lib/plugins/decide"
require_relative "../lib/plugins/memo"
require_relative "../lib/plugins/ai"
require_relative "../lib/plugins/control_panel"
require_relative "../lib/plugins/chanop_cp"
require_relative "../lib/plugins/private_cp"
require_relative "../lib/plugins/priv_chan_cp"
require_relative "../lib/plugins/fact_core"
require_relative "../lib/plugins/act_ai"
require_relative "../lib/plugins/url_scraper"
require_relative "../lib/plugins/twitter"
require_relative "../lib/plugins/twitter_status"
require_relative "../lib/plugins/plugin_management"
require_relative "../lib/plugins/wikipedia"
require_relative "../lib/plugins/weather"
#require_relative "../lib/plugins/google"
require_relative "../lib/plugins/you_tube"
require_relative "../lib/plugins/math"
require_relative "../lib/plugins/user_info"
require_relative "../lib/plugins/isitup"
require_relative "../lib/plugins/relationship_handler"
require_relative "../lib/plugins/ignore_handler"
require_relative "../lib/plugins/admin_handler"
require_relative "../lib/plugins/four_chan"
require_relative "../lib/plugins/dictionary"
require_relative "../lib/plugins/news"
require_relative "../lib/plugins/wolfram"
require_relative "../lib/plugins/reddit"
#require_relative "../lib/plugins/word_game"
require_relative "../lib/plugins/tag"
require_relative "../lib/plugins/coin_query"
require_relative "../lib/plugins/last_fm"

## Written by Richard Banks for Eve-Bot "The Project for a Top-Tier IRC bot.
## E-mail: namaste@rawrnet.net
## Github: Namasteh
## Website: www.rawrnet.net
## IRC: irc.sinsira.net #Eve
## If you like Eve-Bot please consider tipping me on gittip
