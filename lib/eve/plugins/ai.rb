require 'cinch'

module Cinch::Plugins
  class AIRespond
    include Cinch::Plugin
  
    def status(m)
      [
        "I have the privilege of serving everywun here, #{m.user.nick}, how do you think I am?",
        "Fantastic as usual, #{m.user.nick}! I was programmed with a sunny disposition!",
        "I'm wonderful! How are you #{m.user.nick}?",
        "I'm just sitting here doing my job #{m.user.nick}, and loving it!",
        "I'm great! Thanks for asking, #{m.user.nick}!"
      ].sample
    end
	
    def hir(m)
      [
        "Hello #{m.user.nick}",
        "Hey there #{m.user.nick}!",
        "Greetings #{m.user.nick}, I'm ready to serve!",
        "Well, hi #{m.user.nick}!"
      ].sample
    end
    
    def brbr(m)
      [
        "Hurry back #{m.user.nick}",
        "I'll be waiting on pins and needles, #{m.user.nick}!",
        "Try not to be too long, we'll miss you, #{m.user.nick}."
      ].sample
    end
    
    def supr(m)
      [
        "If I had a method for that, I would use it #{m.user.nick}.",
        "My programming does aim to please, however, it has no understanding of what to shut, and why it must be shut upwards, #{m.user.nick}",
        "I promise I will remain silent until spoken to, or until someone joins or parts the channel, #{m.user.nick}.",
        "If that is your wish you must speak to my master, #{m.user.nick}."
      ].sample
    end
    
    def tyr(m)
      [
        "You are very welcome, #{m.user.nick}!",
        "It is my pleasure to serve you, #{m.user.nick}!",
        "I am always ready to do my job, #{m.user.nick}!",
        "Any time, #{m.user.nick}!",
        "If you ever need a hand, I'm always here #{m.user.nick}!",
        "I should thank YOU for using me, #{m.user.nick}!",
        "Aww you're welcome #{m.user.nick}! I want to hold your hand!"
      ].sample
    end
    
    def ywr(m)
      [
        ":D"
      ].sample
    end
      
    match lambda {|m| /#{m.bot.nick}, how are you/}, :method => :hau, use_prefix: false
    match lambda {|m| /#{m.bot.nick} how are you/}, :method => :hau, use_prefix: false
    match lambda {|m| /How are you, #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /How are you #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /how are you, #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /how are you #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /how are you doing, #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /how are you doing #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /How are you doing #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /How are you doing, #{m.bot.nick}/}, :method => :hau, use_prefix: false
    match lambda {|m| /Hello #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match lambda {|m| /Hello, #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match lambda {|m| /hello #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match lambda {|m| /hello, #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match lambda {|m| /hello, #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match lambda {|m| /Hi, #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match lambda {|m| /Hi #{m.bot.nick}/}, :method => :hi, use_prefix: false
    match /brb/, :method => :brb, use_prefix: false
    match /bbs/, :method => :brb, use_prefix: false
    match lambda {|m| /Shut up #{m.bot.nick}/}, :method => :sup, use_prefix: false
    match lambda {|m| /shut up #{m.bot.nick}/}, :method => :sup, use_prefix: false
    match lambda {|m| /Shut up, #{m.bot.nick}/}, :method => :sup, use_prefix: false
    match lambda {|m| /shut up, #{m.bot.nick}/}, :method => :sup, use_prefix: false
    match lambda {|m| /#{m.bot.nick}, shut up/}, :method => :sup, use_prefix: false
    match lambda {|m| /#{m.bot.nick} shut up/}, :method => :sup, use_prefix: false
    match lambda {|m| /Thank you, #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /thank you, #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /Thank you #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /thank you #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /ty #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /ty, #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /TY #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /TY, #{m.bot.nick}/}, :method => :ty, use_prefix: false
    match lambda {|m| /yw #{m.bot.nick}/}, :method => :yw, use_prefix: false
    match lambda {|m| /yw, #{m.bot.nick}/}, :method => :yw, use_prefix: false
    match lambda {|m| /You're welcome #{m.bot.nick}/}, :method => :yw, use_prefix: false
    match lambda {|m| /You're welcome, #{m.bot.nick}/}, :method => :yw, use_prefix: false
    match lambda {|m| /you're welcome #{m.bot.nick}/}, :method => :yw, use_prefix: false
    match lambda {|m| /you're welcome, #{m.bot.nick}/}, :method => :yw, use_prefix: false
    
    def hau(m)
      m.reply status(m)
    end
	
    def hi(m)
      m.reply hir(m)
    end
	
    def brb(m)
      m.reply brbr(m)
    end
  
    def sup(m)
      m.reply supr(m)
    end
    
    def ty(m)
      m.reply tyr(m)
    end
    
    def yw(m)
      m.reply ywr(m)
    end
  end
end