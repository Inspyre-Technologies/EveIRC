require 'cinch'
require_relative "config/check_user"

# This is a Channel Operator Control Panel. Please make sure
# that you have check_user configured to the AUTHNAMES that
# you want to have access to these commands! Some of these
# commands can be abused so please only add users that you
# can trust not to give you and Eve a bad name!

module Cinch::Plugins
  class ChanopCP
    include Cinch::Plugin
    include Cinch::Helpers
  
# The following command is to be used in a channel. It will
# give the user op in the channel they are using it if Eve
# is also op in that channel. Eve will report use of this 
# command for security purposes.
  
    match /opme/, method: :execute_op
  
    def execute_op(m)
      if m.channel
        unless check_user(m.user)
          m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
          bot.info("Received invalid OpMe command from #{m.user.nick}")
        return;
      end
        unless m.channel.opped?(m.user) == false
          m.reply ("You are already opped in this channel!")
        return;
      end
        unless m.channel.opped?(m.bot) == true
          m.reply ("I can not op you, because I am not opped")
        return;
      end
        bot.info("Received valid OpMe command from #{m.user.nick}")
        m.reply Format(:green, "Very well...")
        bot.irc.send ("MODE #{m.channel} +o #{m.user.nick}")
      end
    end
    
# This will de-op you in the channel.
    
    match /deopme/, method: :execute_deop
    
    def execute_deop(m)
      if m.channel
        unless check_user(m.user)
          m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
          bot.info("Received invalid deopme command from #{m.user.nick}")
        return;
      end
        unless m.channel.opped?(m.user) == true
          m.reply ("You have no op to take!")
        return;
      end
        unless m.channel.opped?(m.bot) == true
          m.reply ("I can't de-op you because I'm not opped!")
        return;
      end
        bot.info("Received valid deop command from #{m.user.nick}")
        m.reply Format(:green, "Very well...")
        bot.irc.send ("MODE #{m.channel} -o #{m.user.nick}")
      end
    end
    
# When I designed this plugin it was in my mind to
# use Eve as a channel helper, for various reasons.
# None of these commands report the nick that uses
# it publicly. So if you need to see who is using
# the commands you need to look in the console.
# The following command will kick a user from 
# the channel with a reason.
    
    set :prefix, /^./
    
    match /kick (#\S+) (\S+)\s?(.+)?/, method: :execute_kick
    
    def execute_kick(m, channel, knick, reason)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid kick command from #{m.user.nick}")
      return;
    end
      unless Bot#channels(m.channel)
        m.reply Format(:red, "I would love to but I am not in that channel")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't make a kick because I am not op in #{channel}")
      return;
    end
        bot.info("Received valid kick command from #{m.user.nick}")
        m.reply Format(:green, "Very well...")
        Channel(channel).kick(knick, reason)
      end
  
# The following command will ban a user from a channel
# you just give Eve the nick, she will determine the 
# mask and ban tha mask.
  
    set :prefix, /^./
  
    match /ban (#\S+) (\S+)/, method: :execute_ban
  
    def execute_ban(m, channel, user)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invaled ban command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't ban #{user} because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid ban command from #{m.user.nick}")
      user = User(user)
      mask = user.mask("*!*@%h")
      m.reply Format(:green, "Very well...")
      Channel(channel).ban(mask)
    end
    
# The following command will unban a mask from a 
# channel. This means you must specify the mask that
# you want to unban.
    
    set :prefix, /^./
  
    match /unban (#\S+) (\S+)/, method: :execute_unban
  
    def execute_unban(m, channel, mask)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid unban command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't unban #{mask} because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid unban command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      Channel(channel).unban(mask)
    end
    
# The following command is a combination of kick and
# ban. Again, just use the nick, Eve will ascertain
# the mask on her own.

    
    set :prefix, /^./
    
    match /kban (#\S+) (\S+)(?: (.+))?/, method: :execute_kban
    
    def execute_kban(m, channel, user, reason)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid kban command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't kban #{user} because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid kban command from #{m.user.nick}")
      user = User(user)
      mask = user.mask("*!*@%h")
      m.reply Format(:green, "Very well...")
      Channel(channel).ban(mask)
      Channel(channel).kick(user, reason)
    end
    
# Unlike the above !opme command, this command will
# op another user and and should be done in PM with
# Eve.
    
    set :prefix, /^./
    
    match /op (#\S+) (\S+)(?: (.+))?/, method: :execute_rop
    
    def execute_rop(m, channel, user)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid op command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't op #{user} because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid op command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} +o #{user}")
    end
    
# This command will de-op a user that you specify 
# whilst giving her the command in a PM.
    
    set :prefix, /^./
    
    match /deop (#\S+) (\S+)(?: (.+))?/, method: :execute_rdop
    
    def execute_rdop(m, channel, user)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid deop command from #{m.user.nick}. User attempted to op #{user} in #{channel}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't deop #{user} because I am not op in #{channel}")
        bot.info("Valid deop command failed because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid deop command from #{m.user.nick} for #{channel}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} -o #{user}")
    end
    
# The following command will have Eve give voice
# to the user of your choice. 
    
    set :prefix, /^./
    
    match /voice (#\S+) (\S+)(?: (.+))?/, method: :execute_rv
    
    def execute_rv(m, channel, user)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid voice command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't give voice to #{user} because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid voice command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} +v #{user}")
    end
    
# The following command will have Eve take voice
# from who you ask her too.
    
    set :prefix, /^./
    
    match /devoice (#\S+) (\S+)(?: (.+))?/, method: :execute_rdv
    
    def execute_rdv(m, channel, user)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid devoice command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't take voice from #{user} because I am not op in #{channel}")
      return;
    end
      bot.info("Received valid devoice command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} -v #{user}")
    end
    
# The following command changes the title in the given channel
# and for some reason colors at the beginning of the title
# are stripped so please keep this in mind.

    set :prefix, /^./
    
    match /t (#.+?) (.+)/, method: :execute_topic
    
    def execute_topic(m, channel, topic)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid topic command from #{m.user.nick}")
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't change the topic in #{channel} because I am not op.")
      return;
    end
      bot.info("Received valid topic command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("TOPIC #{channel} #{topic}")
    end
  end
end

# A FEW NOTES:
# 1.) If you need further help with the commands and their syntax just type !help in a channel
# that Eve is in and she will send you a vast array of commands at your disposal.
#
# 2.) As a rule it is never, EVER nice to use IRC bots or any other means to abuse channel op
# privileges! There are several reasons I included public anonymity; none of which include
# abuse of power!
#
# As a last note, always remember that EVE is a project for a Top-Tier IRC bot, and the project
# could always use more help. Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at rawr.coreirc.org