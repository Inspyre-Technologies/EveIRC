require 'cinch'

module Cinch::Plugins
  class ChristmasBoxx
    include Cinch::Plugin
    
    set :prefix, /^~/
    set :plugin_name, 'christmasboxx'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      A plugin full of Christmas goodies
      Usage:
      - ~present <user>: Gives <user> a gift from you!
      - ~cracker <user>: Gives you and the other user a Christmas cracker! See who wins!
      - ~mistletoe <user>: You know how this works...
      USAGE
      
    def presentg(m, user)
      [
        "gives #{user} a present! It's tag reads 'To: #{user} - From: #{m.user.nick}. "
      ].sample
    end
    
    def presents(m, user)
     [
       "has given #{user} a gift card to the store at CatieWayne.com! Happy shopping!",
       "has given #{user} underwear!",
       "has given #{user} a box full of coal! Try not to get it all over the channel!",
       "has given #{user} a six-pack of socks. Well, at least you'll be warm this Christmas!",
       "has given #{user} a DVD set with all of Boxxy and Catie Wayne's videos in HD!",
       "has given #{user} a Lego Star Wars X-Wing Fighter kit! May the force be with you, #{user}.",
       "has given #{user} a box of chocolates, I wonder what you'll get!",
       "has given #{user} tickets to WrestleMania!",
       "has given #{user} tickets to this year's VidCon! See you there #{user}!"
     ].sample
   end
   
   match /present (.+)/, method: :present
   
   def present(m, user)
     sleep config[:delay] || 3
     m.channel.action presentg(m, user)
     sleep config[:delay] || 2
     m.channel.action presents(m, user)
   end
   
   match /cracker (.+)/, method: :cracker
   
   def cracker(m, user)
     winner = Random.new.rand(1..2) == 1 ? "#{m.user.nick}" : "#{user}";
     m.channel.action "gives #{user} and #{m.user.nick} a Christmas cracker!"
     sleep config[:delay] || 3
     m.reply Format(:green, "Now pull!")
     sleep config[:delay] || 5
     m.channel.action "watches as the cracker breaks, making a loud POP sound. A party hat, and a Boxxy figurine fall out."
     m.reply Format(:green, "The winner is #{winner}!");
   end
   
   match /mistletoe (.+)/, method: :mistletoe
   
   def mistletoe(m, user)
     m.channel.action "holds a sprig of mistletoe over #{user}'s head!"
     m.reply Format(:green, "You know the rules of mistletoe! Now kiss! :3")
   end
 end
end
   
# EVE is a project for a Top-Tier IRC bot, and the project could always use more help.
# Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at rawr.sinsira.net   