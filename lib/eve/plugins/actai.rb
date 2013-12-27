require 'cinch'

module Cinch::Plugins
  class ActAI
    include Cinch::Plugin
    listen_to :action
    
    def hugar(m)
      [
        "hugs #{m.user.nick} tight!",
        "hugs #{m.user.nick} with much love"
      ].sample
    end
      
    def hugr(m)
      [
        Format(:green, "Do I ever have to let you go, #{m.user.nick}?"),
        Format(:green, "Thanks for the hug, I love you #{m.user.nick}!")
      ].sample
    end
    
    def kissar(m)
      [
        "smooches #{m.user.nick} right on the forehead!",
        "smooches #{m.user.nick} right on the mouth!",
        "gives #{m.user.nick} a big kiss!",
        "blushes and grabs #{m.user.nick}, giving a huge smooch right back!",
        "swoons and collapses!",
        "bites lower lip and eyes #{m.user.nick} before tackling and giving a giant kiss!"
      ].sample
    end
    
    def kissr(m)
      [
        Format(:green, "Oh #{m.user.nick}, I never knew you had THAT talent!"),
        Format(:green, "You are amazing, #{m.user.nick}!"),
        Format(:green, "Wow, I feel all warm and tingly in my lambdas!"),
        Format(:green, "...and IIIIIIIIIII will always love YOUUUUUUUU..."),
        Format(:green, "#{m.user.nick}, you're gonna get me all hot and bothered!")
      ].sample
    end
    
    def dirtyar(m)
      [
        "slaps #{m.user.nick}.",
        "punches #{m.user.nick} in the face!"
      ].sample
    end
    
    def dirtyr(m)
      [
        Format(:green, "That is inappropriate! D:<"),
        Format(:green, "I'm a lady, not a whore!"),
        Format(:green, "Don't disrepsect me like that! Rude-ass!")
      ].sample
    end
    
    def cuddlear(m)
      [
        "cuddles with #{m.user.nick}.",
        "snuggles close, and purrs."
      ].sample
    end
    
    def cuddler(m)
      [
        Format(:green, "Can we stay like this forever, #{m.user.nick}?"),
        Format(:green, "Oh I love cuddles, #{m.user.nick}!")
      ].sample
    end
    
    def highfivear(m)
      [
        "gives #{m.user.nick} a high-five back! :D",
        "high-fives!",
        "high-fives #{m.user.nick}!"
      ].sample
    end
    
    def highfiver(m)
      [
        Format(:green, "Oh yeah #{m.user.nick}!"),
        Format(:green, "Now we should watch Across the Universe, #{m.user.nick}!")
      ].sample
    end
       
    def handholdar(m)
      [
        "holds #{m.user.nick}'s hand.",
        "holds hands with #{m.user.nick}, swinging it slightly.",
        "takes #{m.user.nick}'s hand and holds it, smiling."
      ].sample
    end
    
    def handholdr(m)
      [
        Format(:green, "Oh #{m.user.nick}. I feel so loved!"),
        Format(:green, "I love this moment, #{m.user.nick}!"),
        Format(:green, "Hand-holds always make me feel good, #{m.user.nick}.")
      ].sample
    end
    
    match lambda {|m| /hugs #{m.bot.nick}/i}, :method => :hug, use_prefix: false
    match lambda {|m| /gives #{m.bot.nick} a hug/i}, :method => :hug, use_prefix: false
    match lambda {|m| /gives #{m.bot.nick} a (kiss|smooch)/i}, :method => :kiss, use_prefix: false
    match lambda {|m| /(smooches|kisses|snogs) #{m.bot.nick}/i}, :method => :kiss, use_prefix: false
    match lambda {|m| /(grinds|humps) #{m.bot.nick}/i}, :method => :dirty, use_prefix: false
    match lambda {|m| /(grinds|humps) on #{m.bot.nick}/i}, :method => :dirty, use_prefix: false
    match lambda {|m| /(snuggles|cuddles)( with|) #{m.bot.nick}/i}, :method => :cuddle, use_prefix: false
    match lambda {|m| /gives #{m.bot.nick} a (high-five|highfive|high five)/i}, :method => :highfive, use_prefix: false
    match lambda {|m| /(high-fives|highfives|high fives) #{m.bot.nick}/i}, :method => :highfive, use_prefix: false
    match lambda {|m| /holds hands with #{m.bot.nick}/i}, :method => :handhold, use_prefix: false
    
    
    def hug(m)
      sleep config[:delay] || 3
      m.channel.action hugar(m)
      sleep config[:delay] || 2
      m.reply hugr(m)
    end
    
    def kiss(m)
      sleep config[:delay] || 3
      m.channel.action kissar(m)
      sleep config[:delay] || 2
      m.reply kissr(m)
    end
    
    def dirty(m)
      sleep config[:delay] || 3
      m.channel.action dirtyar(m)
      sleep config[:delay] || 2
      m.reply dirtyr(m)
    end
    
    def cuddle(m)
      sleep config[:delay] || 3
      m.channel.action cuddlear(m)
      sleep config[:delay] || 2
      m.reply cuddler(m)
    end
    
    def highfive(m)
      sleep config[:delay] || 3
      m.channel.action highfivear(m)
      sleep config[:delay] || 2
      m.reply highfiver(m)
    end
    
    def handhold(m)
      sleep config[:delay] || 3
      m.channel.action handholdar(m)
      sleep config[:delay] || 2
      m.reply handholdr(m)
    end
  end
end