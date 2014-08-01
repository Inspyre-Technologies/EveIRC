require 'cinch'
require_relative "config/check_ignore"

module Cinch::Plugins
  class ValentineBoxx
    include Cinch::Plugin

    set :plugin_name, 'valentineboxx'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
    A plugin full of Valentine's Day goodies!
    Usage:
    - !poem <user>: Gives <user> Valentine's day poem from you!
    - !sweetheart <user>: Gives <user> a classic Sweethearts candy with a phrase!
    - !rose <user>: You know how this works...
    USAGE

    def poems(m, user)
      [
        Format(:pink, "%s; \"People come and people go, in and out of your life and so, when one shines bright among the rest, and is there when needed, you're truly blessed. That is how I see you, friend of mine, and why I'm sending this Valentine.\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        Format(:pink, "%s; \"Friendship is a wondrous thing; there's so much happiness it can bring. I'm really glad that you're my friend, and I hope our friendship will never end. Happy Valentines Day friend!\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        Format(:pink, "%s; \"You'll never know what you mean to me, and how important you've come to be. We share special days as our lives entwine, and that's why I send you this Valentine.\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        Format(:pink, "%s; \"A friend is like a Valentine, heartwarming, bringing pleasure, connected to good feelings, with memories to treasure. Seeing a special Valentine brings happiness to stay, and that's what you do, friend, you brighten every day!\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        Format(:pink, "%s; \"Valentine, I feel so good each time that we're together. We're similar souls in harmony, birds of a kindred feather. Our hearts sing to the same sweet tune; Our compatible minds align; Could you, would you, pretty please, be my Valentine?\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        Format(:pink, "%s; \"Thoughts of affection fill my mind when Valentine's Day is near; I think about my closest friends, those who are most dear. And on that special Valentine list, you're at the top, my friend. I love you, and I know for sure, our friendship will never end!\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        Format(:pink, "%s; \"If I could create the perfect friend, one of my own design, a friend to be my companion, a friend for a Valentine, I'd build them with a giving heart filled with kindness, too, a friend who's also lots of fun, but I've already got one--you!\"" % [Format(:bold, "From: #{m.user.nick}, To: #{user}")]),
        ].sample
    end

    def sweethearts(m, user)
      [
        Format(:pink, "MELT MY ♥"),
        Format(:pink, "CHILL OUT"),
        Format(:pink, "RECIPE 4 LOVE"),
        Format(:pink, "TABLE 4 TWO"),
        Format(:pink, "STIR MY ♥"),
        Format(:pink, "MY TREAT"),
        Format(:pink, "TOP CHEF"),
        Format(:pink, "URA TIGER"),
        Format(:pink, "GO FISH"),
        Format(:pink, "LOVE BIRD"),
        Format(:pink, "PURR FECT"),
        Format(:pink, "SWEET LOVE"),
        Format(:pink, "BE MY HERO"),
        Format(:pink, "♥ OF GOLD"),
        Format(:pink, "EVER AFTER"),
        Format(:pink, "TWO HEARTS"),
        ].sample
    end

    match /poem (.+)/i, method: :poem

    def poem(m, user)
      return if check_ignore(m.user)
      sleep config[:delay] || 3
      m.reply poems(m, user)
    end

    match /sweetheart (.+)/i, method: :sweetheart

    def sweetheart(m, user)
      return if check_ignore(m.user)
      sleep config[:delay] || 3
      m.channel.action "has given #{user} a Sweetheart"
      sleep config[:delay] || 2
      m.reply sweethearts(m, user)
    end

    match /rose (.+)/i, method: :rose

    def rose(m, user)
      return if check_ignore(m.user)
      m.channel.action "gives #{user} a Valentine rose from #{m.user.nick}"
      m.reply Format(:green, "--<--<--%s" % [Format(:pink, "@")])
    end
  end
end

## Written by Richard Banks for Eve-Bot "The Project for a Top-Tier IRC bot.
## E-mail: namaste@rawrnet.net
## Github: Namasteh
## Website: www.rawrnet.net
## IRC: irc.sinsira.net #Eve
## If you like this plugin please consider tipping me on gittip
