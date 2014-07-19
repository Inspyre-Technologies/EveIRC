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

  [1]: https://developer.wolframalpha.com/portal/apisignup.html