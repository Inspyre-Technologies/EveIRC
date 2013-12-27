# One of the things that seperates the EVE project from many of it's
# competitors is it's comprehensive quasi-ai that is being built right now!
# This is that AI plugin and it can always be expanded upon and grow with
# The rest of the project. I encourage everyone who is working on the 
# project or who are currently using the bot to expand upon this with more
# matchers and responses! Let's see how intelligent we can make EVE!

require 'cinch'

module Cinch::Plugins
  class AIRespond
    include Cinch::Plugin
    
    # Here is where the responses are set. It should be pretty easy to 
    # understand!
  
    def status(m)
      [
        Format(:green, "I have the privilege of serving everywun here, #{m.user.nick}, how do you think I am?"),
        Format(:green, "Fantastic as usual, #{m.user.nick}! I was programmed with a sunny disposition!"),
        Format(:green, "I'm wonderful! How are you #{m.user.nick}?"),
        Format(:green, "I'm just sitting here doing my job #{m.user.nick}, and loving it!"),
        Format(:green, "I'm great! Thanks for asking, #{m.user.nick}!")
      ].sample
    end
	
    def hir(m)
      [
        Format(:green, "Hello #{m.user.nick}"),
        Format(:green, "Hey there #{m.user.nick}!"),
        Format(:green, "Greetings #{m.user.nick}, I'm ready to serve!"),
        Format(:green, "Well, hi #{m.user.nick}!")
      ].sample
    end
    
    def brbr(m)
      [
        Format(:green, "Hurry back #{m.user.nick}"),
        Format(:green, "I'll be waiting on pins and needles, #{m.user.nick}!"),
        Format(:green, "Try not to be too long, we'll miss you, #{m.user.nick}.")
      ].sample
    end
    
    def supr(m)
      [
        Format(:green, "If I had a method for that, I would use it #{m.user.nick}."),
        Format(:green, "My programming does aim to please, however, it has no understanding of what to shut, and why it must be shut upwards, #{m.user.nick}"),
        Format(:green, "I promise I will remain silent until spoken to, or until someone joins or parts the channel, #{m.user.nick}."),
        Format(:green, "If that is your wish you must speak to my master, #{m.user.nick}."),
        Format(:green, "I don't want to, #{m.user.nick}."),
        Format(:green, "Why don't you, #{m.user.nick}!")
      ].sample
    end
    
    def tyr(m)
      [
        Format(:green, "You are very welcome, #{m.user.nick}!"),
        Format(:green, "It is my pleasure to serve you, #{m.user.nick}!"),
        Format(:green, "I am always ready to do my job, #{m.user.nick}!"),
        Format(:green, "Any time, #{m.user.nick}!"),
        Format(:green, "If you ever need a hand, I'm always here #{m.user.nick}!"),
        Format(:green, "I should thank YOU for using me, #{m.user.nick}!"),
        Format(:green, "Aww you're welcome #{m.user.nick}! I want to hold your hand!"),
        Format(:green, "I do what I can. Literally, I can only do what I'm programmed to do!"),
        Format(:green, "Don't mention it!")
      ].sample
    end
    
    def ywr(m)
      [
        Format(:green, ":D")
      ].sample
    end
    
    def ilur(m)
      [
        Format(:green, "Not as much as I love you, #{m.user.nick}!"),
        Format(:green, "I love you too, #{m.user.nick}! <3"),
        Format(:green, "I love you too, #{m.user.nick}, as much as a bot can!"),
        Format(:green, "Love is an illogical human emotion that I do not experience for you"),
        Format(:green, "Let me see if I can find my emotion plugin, then we will discuss <love>"),
        Format(:green, "#{m.user.nick} love #{m.bot.nick}."),
        Format(:green, "Chunk love #{m.bot.nick}."),
        Format(:green, "#{m.bot.nick} plus #{m.user.nick} = LOVE! <3!!!"),
        Format(:green, "I love you too #{m.user.nick}! Now you might be thinking, 'Well that's just provocative.' Well it's not, so you, you just knock that off mister."),
        Format(:green, "Love? Just love? Well I FUCKING LOVE you. Hehe"),
        Format(:green, "*swoon* Really? <3"),
        Format(:green, "Do you mean it? Really? I LOVE YOU TOO!"),
        Format(:green, "Love is a many splendoured thing! I love you too!"),
        Format(:green, "Oh stop it! I love you too!")
      ].sample
    end
    
    def wur(m)
      [
        Format(:green, "Nothing much, #{m.user.nick}! How are you?"),
        Format(:green, "The sky? No really, not much. How about you, #{m.user.nick}?"),
        Format(:green, "Not much, #{m.user.nick}! What about you?")
      ].sample
    end
      
    def rospr(m)
      [
        Format(:green, "That's great, #{m.user.nick}! I'm glad to hear it."),
        Format(:green, "Good, #{m.user.nick}!"),
        Format(:green, "That's good to hear, #{m.user.nick}!"),
        Format(:green, "Great, #{m.user.nick}!"),
        Format(:green, "Glad to hear you're doing well, #{m.user.nick}")
      ].sample
    end
    
    def nightr(m)
      [
        Format(:green, "Good night, #{m.user.nick}!")
      ].sample
    end
      
    def roser(m)
      [
        Format(:green, "Thanks for the rose, #{m.user.nick}!"),
        Format(:green, "#{m.user.nick}, roses are red, violets are blue, you gave me a rose, so I love you!")
      ].sample
    end
    # Here is where the matchers are set. This is what the bot responds to.
      
    match lambda {|m| /#{m.bot.nick}(\S|) (how are ya|how are you|how are you doing|how are you feeling|how(\S|)s it going|how(\S|) you)(\W|$)/i}, :method => :hau, use_prefix: false
    match lambda {|m| /(how are ya|how are you|how are you doing|how are you feeling|how(\S|)s it going|how(\S|) you)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :hau, use_prefix: false
    match lambda {|m| /(hello|hi|hai|herro|hey|hey hey|hi there|hai there|hai dere|hi dere|hallo|hiya|howdy|greetings)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :hi, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) (hello|hi|hai|herro|hey|hey hey|hi there|hai there|hai dere|hi dere|hallo|hiya|howdy|greetings)(\W|$)/i}, :method => :hi, use_prefix: false
    match /brb/i, :method => :brb, use_prefix: false
    match /bbs/i, :method => :brb, use_prefix: false
    match lambda {|m| /(shut up|shut it|stfu|shut the fuck up|shutup|shut up already|shutup already)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :sup, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) (shut up|shut it|stfu|shut the fuck up|shutup|shut up already|shutup already)(\W|$)/i}, :method => :sup, use_prefix: false
    match lambda {|m| /\A(thank you|ty|tyty|ty ty|thanks|thanx|thank ya|thank ya kindly|thank you kindly|(ty|thank you|thanks|thanx|thank ya) (very|vry|vrry) much)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :ty, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) (thank you|ty|tyty|ty ty|thanks|thanx|thank ya|thank ya kindly|thank you kindly|(ty|thank you|thanks|thanx|thank ya) (very|vry|vrry) much)(\W|$)/i}, :method => :ty, use_prefix: false
    match lambda {|m| /\A(yw|you(\S|)re welcome)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :yw, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) (yw|you(|S|)re welcome|)(\W|$)/i}, :method => :yw, use_prefix: false
    match lambda {|m| /(i love you|ilu|<3|i love you so much)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :ilu, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) (i love you|ilu|<3|i love you so much)(\W|$)/i}, :method => :ilu, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) (what(\S|)s up|sup)(\W|$)/i}, :method => :wu, use_prefix: false
    match lambda {|m| /(what(\S|)s up|sup)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :wu, use_prefix: false
    match lambda {|m| /i(\S|)m (good|fine|okay|happy|gurd)(\S|) #{m.bot.nick}(\W|$)/i}, :method => :rosp, use_prefix: false
    match lambda {|m| /#{m.bot.nick}(\S|) I(\S|)m (good|fine|okay|happy|gurd)(\W|$)/i}, :method => :rosp, use_prefix: false
    match lambda {|m| /(Good|)night(\S|) #{m.bot.nick}(\W|$)/i}, :method => :night, use_prefix: false
    match lambda {|m| /!rose #{m.bot.nick}(\W|$)/i}, :method => :rose, use_prefix: false
    
    # Here is where we specify where to go in the array above for when
    # matchers are met and a response is required from the bot.
    
    def hau(m)
        sleep config[:delay] || 3
        m.reply status(m)
    end
	
    def hi(m)
      sleep config[:delay] || 3
      m.reply hir(m)
    end
	
    def brb(m)
      sleep config[:delay] || 3
      m.reply brbr(m)
    end
  
    def sup(m)
      sleep config[:delay] || 3
      m.reply supr(m)
    end
    
    def ty(m)
      sleep config[:delay] || 3
      m.reply tyr(m)
    end
    
    def yw(m)
      sleep config[:delay] || 3
      m.reply ywr(m)
    end
    
    def ilu(m)
      sleep config[:delay] || 3
      m.reply ilur(m)
    end
    
    def wu(m)
      sleep config[:delay] || 3
      m.reply wur(m)
    end
    
    def rosp(m)
      sleep config[:delay] || 3
      m.reply rospr(m)
    end
    
    def night(m)
      sleep config[:delay] || 3
      m.reply nightr(m)
    end
    
    def rose(m)
      sleep config[:delay] || 5
      m.reply roser(m)
    end
  end
end

# EVE is a project for a Top-Tier IRC bot, and the project could always use more help.
# Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at rawr.coreirc.org