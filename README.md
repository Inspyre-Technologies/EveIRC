# Eve-Bot

## EVE: A Project for a Top-Tier IRC Bot

Eve was originally designed on an entirely different framework and language and has grown through the years.

Now Eve is on Ruby and the Cinch IRC Framework.

###--Installation--
Eve and several of it's plugins have some dependencies. The first of which are very important, you need Ruby, RVM, and RubyGems. If you already have those installed then you can skip ahead to: -Section B: Installing The Framework-.

###-Section A: Installing Ruby, RVM, and RubyGems-

1.) The first thing we need to do is make sure that your package manager is up to date:

`sudo apt-get update`

2.) If you don't have curl you need to install it now:

`sudo apt-get install curl`

3.) Now you need to install RVM:

`curl -L https://get.rvm.io | bash -s stable`

4.) Now you need to load RVM:

`source ~/.rvm/scripts/rvm`

5.) Now you need to install RVM's dependencies:

`rvm requirements`

6.) Now you need to install Ruby:

`rvm install ruby`

7.) Now you need to tell the system what version to use as default:

`rvm use ruby -default`

8.) Now you need to install RubyGems:

`rvm rubygems current`

Excellent. Now you are done installing RVM, Ruby, and RubyGems!

###-Section B: Installing the Framework-

1.) This is really easy:

`gem install cinch`

###-Section C: Installing Plugin Dependencies-

As of now there are only two dependencies needed for the plugins.

1.) If you want to have Eve do anything that has to do with web fetching you must install the Nokogiri gem:

`gem install nokogiri`

2.) If you want to have Eve fetch tweets from any twitter account you need to install the Twitter gem:

`gem install twitter`

3.) Most of Eve's plugins rely on JSON:

`gem install json`

4.) We need OJ

`gem install oj`

5.) We also need mechanize

`gem install mechanize`

6.) Can't run without time-lord

`gem install time-lord`

7.) You need to get the Cinch toolbox

`gem install cinch-toolbox`

8.) If you want to install all of them

`gem install nokogiri && gem install json && gem install oj && gem install mechanize && gem install time-lord && gem install twitter && gem install cinch-toolbox`

###-Section D: Getting Eve-

Now you just need to get Eve from the repo:

`git clone https://github.com/Namasteh/Eve-Bot.git`

###-Section E: Configuring Eve-

Alright now that you have Eve, and all the dependencies it takes to run her you must configure it. Use a code editor (I use Notepad ++) to open ~/Eve-Bot/Eve.rb it should be fairly easy to figure out the configuration.

The first section is the include area, you need to put the plugins that you have in this area, if you're going to remove plugins you need to delete their require line.

Then you need to configure the Server, Nick, and Channels.

Next you need to make sure the plugins you want loaded are in the c.plugins.plugins section, the plugins won't work if you don't load it here, and if you load a plugin that doesn't exist the bot will not start!

Next are your Twitter options, you need to put your API keys in this section or the Twitter plugin will not work!

In c.password you need to put Eve's NickServ pass so she can identify upon connecting.

###-Section F: Adding Yourself As Master-

When you run Eve, you will need the bot to recognize you as master, and you must add yourself as a master to the bot's userinfo.yaml file in order for any of the userinfo dependent plugins to work.

So open docs/userinfo.yaml and place the following inside, save, and close

    ---
    yourircnick:
      auth: yourauthname
      master: true

Plugins & Configuration
=======
The following section includes configuration options for some of the plugins that are not required but are enabled by default on the bot. Please read this before coming to IRC to ask questions.

## Wolfram|Alpha ##

***Configuration:***

For this plugin to operate it requires a dependancy to be installed.

    gem install wolfram-alpha

After installing that dependency you are fully able to use the plugin, the following is required to insert into Eve.rb for operation.

At the beginning of Eve.rb in the required scripts section put this:

    require_relative "lib/eve/plugins/wolfram"

In the c.plugins section of Eve.rb put this:

    [Cinch::Plugins::Wolfram]

Finally in the configuration section of Eve.rb put this:

    c.plugins.options[Cinch::Plugins::Wolfram] = { key: 'foo' }

The only thing that **must** be edited out of these lines is c.plugins.options and you must change the 'foo' to **your** Wolfram|Alpha API key, which you can get from [this website][1]. **You can not use the plugin if this option is not configured properly!**

***Usage:***

The bot comes with a comprehensive help system and the Wolfram|Alpha plugin was integrated into this system by default. To receive help in a personal message withe the bot (or even in a channel, though not advised) you can use the following command which will output information on how to use the plugin:

    !help wolfram

To use the functions of the plugin you simply have to use the trigger !wa followed by the query you wish to send to Wolfram|Alpha for calculation and the bot will return with the results (if available).

> [04:44:23] <@Namaste> !wa how old is boxxy?
[04:44:25] <@Eve> age | of Boxxy |  today   = 22 years 2 months 21 days

##Reddit##

***Description:***

The *Reddit* plugin allows users to query Reddit for useful information such as a user's karma count, moderators and subscribers on a subreddit, and search and display thread data all while working in an IRC channel.

***Dependencies***

 - JSON*
 - OpenURI*
 - CGI*
 - [ActionView][2]
 - Date*

In order for this plugin to work at all you will need to already have these dependencies installed or you need to install them before trying to load the plugin. Dependencies marked with a * are already available out-of-the-box on at least Ruby 1.9.

***Required Eve Plugins/Helpers:***

 - CheckIgnore (Helper)

Without this helper, the bot will throw an exception saying that *check_ignore* is an unidentified method or variable. If you've removed this from the bot, please put it back. If you're using just this plugin for your own bot, please check out the cinch-reddit gem instead.

***Configuration:***

In order for this plugin to work the following is required to insert into Eve.rb for operation.

At the beginning of Eve.rb in the required scripts section put this:

    require_relative "lib/eve/plugins/reddit"

In the c.plugins section of Eve.rb put this:

    [Cinch::Plugins::Reddit]

No API keys are needed for this plugin as it utilizes a RESTful API and does not query data that isn't public.

***Usage:***

The bot comes with a comprehensive help system and the *Reddit* plugin was incorporated by default. You can use the !help reddit command to get a full list of commands:

 - **!reddit karma (user)**: Check the karma data of <reddit user> and have it displayed in the channel.
 - **!reddit moderators (subreddit)**: This command queries Reddit and returns the moderators of (subreddit).
 - **!reddit subscribers (subreddit**): This command queries Reddit and returns with the number of subscribers of (subreddit).
 - **!reddit lookup (terms)**: This command will look up a thread that matches your terms. (This is a beta command).
 - **!reddit link (reddit link)**: When invoked this command will return with the thread data of (reddit link).

Here are some examples:

> [21:59:31] <@Namaste> !reddit karma ask_me_if_im_a_truck
[21:59:32] <@Eve> ASK_ME_IF_IM_A_TRUCK has 15,604 link karma, and 58,038 comment
> karma
>
> [22:00:10] <@Namaste> !reddit moderators iama
[22:00:11] <@Eve> /r/iama has 21 moderator(s): karmanaut, roastedbagel, brownboy13, lula2488, herpderpherpderp, SupermanV2, squatly, Ooer, flyryan, flippityfloppityfloo, cahaseler, IKingJeremy, grant0, UnholyDemigod, ImNotJesus, orangejulius, anonymous123421, Seraph_Grymm, IAmAMods, AutoModerator, and iama_sidebar
>
> [22:00:52] <@Namaste> !reddit subscribers iama
[22:00:52] <@Eve> /r/iama has 5,941,926 subscribers!
>
> [22:01:27] <@Namaste> !reddit lookup happy
[22:01:28] <@Eve> http://redd.it/28ge4x - "Towns and guilds and temples and stuff" 0(+0|-0) by mp5k13, about 1 month ago, to /r/Mianite
>
> [22:03:35] <@Namaste> !reddit link http://www.reddit.com/r/Mianite/comments/28ge4x/towns_and_guilds_and_temples_and_stuff/
> [22:03:36] <@Eve> |"Towns and guilds and temples and stuff"| 0(+0|-0)
> by mp5k13, about 1 month ago, to /r/Mianite | http://redd.it/28ge4x |


## CoinQuery ##

***Description:***

The *CoinQuery* plugin allows users to query cryptocoin market data using three different APIs.

***Dependencies:***

 - JSON
 - Open-URI
 - OStruct

All of these dependencies are available on Ruby 1.9+ out of the box.

***Required Eve Plugins/Helpers:***

 - CheckIgnore

Without this helper, the bot will throw an exception saying that *check_ignore* is an unidentified method or variable. If you've removed this from the bot, please put it back. If you're using just this plugin for your own bot, please check out the cinch-coinquery gem instead.

***Configuration:***

In order for this plugin to work the following is required to insert into Eve.rb for operation.

At the beginning of Eve.rb in the required scripts section put this:

    require_relative "lib/eve/plugins/coin_query"

In the c.plugins section of Eve.rb put this:

    [Cinch::Plugins::CoinQuery]

No API keys are needed for this plugin as it utilizes a RESTful API and does not query data that isn't public.

***Usage:***

The bot comes with a comprehensive help system and the *CoinQuery* plugin was incorporated by default. You can use the !help coinquery command to get a full list of commands:

* **!coin (altcoin) (conventional currency)**: This will query the API and return the value of (altcoin) in (conventional currency).
* !**coin market (altcoin) (altcoin/conventional currency)**: This will query the API and return the current market data of (altcoin) in (altcoin/conventional currency).
* **!coin pairs**: This will notice you a list of all the valid pairs of currency you can use to query the bot. This does not include all conventional currency.

Here are some examples of the plugin in use:

> [23:29:41] <@Namaste> !coin market btc usd
> [23:29:42] <@Eve> Namaste, BTC - USD | Last Price: 633 USD - High:
> 634.501 USD - Low: 601 USD - Average: 607.971 USD - Selling Price: 634 USD - Buying Price: 605 USD
>
> [23:29:57] <@Namaste> !coin btc usd
> [23:29:59] <@Eve> Namaste, the current BTC price in USD is 587.45.


## WordGame ##
***Description:***

The *WordGame* plugin allows users to play a word guessing game in an IRC channel.

***Dependencies:***

This plugin has no dependencies other than Cinch.

***Required Eve Plugins/Helpers:***

 - CheckIgnore

Without this helper, the bot will throw an exception saying that *check_ignore* is an unidentified method or variable. If you've removed this from the bot, please put it back. If you're using just this plugin for your own bot, please check out the cinch-wordgame gem instead.

***Configuration:***

In order for this plugin to work the following is required to insert into Eve.rb for operation.

At the beginning of Eve.rb in the required scripts section put this:

    require_relative "lib/eve/plugins/word_game"

In the c.plugins section of Eve.rb put this:

    [Cinch::Plugins::WordGame]

Finally, you need to specify a path to your dictionary in word_game.rb:

    	@dict = Dictionary.from_file "/home/user/Eve-Bot/lib/plugins/config/words.txt"

***A future patch will no long require this action by you in the plugin itself.

***Usage:***

The bot comes with a comprehensive help system and the *WordGame* plugin was incorporated by default. You can use the !help wordgame command to get a full list of commands:

* **!word start**: Starts a word guessing game in the channel in which it is invoked.
* **!guess (word)**: Take a guess at the word. The bot will tell you whether your guessed word comes before or after the secret word, alphabetically.
* **!word quit**: This command will end the game and reveal the secret word.

Here's an example of this game being played:

> [23:52:12] <@Namaste> ~word start
[23:52:12] <@Eve> Starting a new word game
[23:52:19] <@Namaste> ~guess pizza
[23:52:19] <@Eve> My word comes after pizza.
[23:52:26] <@Namaste> ~guess zebra
[23:52:27] <@Eve> My word comes before zebra.
[23:52:31] <@Namaste> ~word quit
[23:52:32] <@Eve> You quitter! Alright, the word was: raspiest. Ending the game now!

## Tag ##

***Description:***

The *Tag* plugin allows users in a channel to play a simple tag game.

***Dependencies:***

This plugin has no dependencies other than Cinch.

***Required Eve Plugins/Helpers:***

 - CheckIgnore

Without this helper, the bot will throw an exception saying that *check_ignore* is an unidentified method or variable. If you've removed this from the bot, please put it back. If you're using just this plugin for your own bot, please check out the cinch-tag gem instead.

***Configuration:***

In order for this plugin to work the following is required to insert into Eve.rb for operation.

At the beginning of Eve.rb in the required scripts section put this:

    require_relative "lib/eve/plugins/tag"

In the c.plugins section of Eve.rb put this:

    [Cinch::Plugins::Tag]

***Usage:***

The bot comes with a comprehensive help system and the *Tag* plugin was incorporated by default. You can use the !help tag command to get a full list of commands:

* **!tag start**: Starts a game of tag in the channel in which it is invoked.
* **!tag (user)**: Tag a user and they become 'it'.
* **!tag quit**: This command will end the game of tag.

Here's an example of the game being played:

> [21:40:02] <@Namaste> ~tag start
[21:40:02] <@Eve> New tag game started! Namaste is it!
[21:40:06] <@Namaste> ~tag Mikachu
[21:40:07] <@Eve> Namaste has tagged Mikachu. Mikachu is now it!
[21:40:35] <~Mikachu> ~tag Namaste
[21:40:35] <@Eve> Mikachu has tagged Namaste. Namaste is now it!
[21:40:40] <@Namaste> ~tag quit
[21:40:40] <@Eve> This tag game is over! Time to go home now!


  [1]: https://developer.wolframalpha.com/portal/apisignup.html
  [2]: http://rubygems.org/gems/actionview
