# This is the control panel for Eve. Most of the commands you'll use as an admin will
# run off of this plugin. Please make sure that you've configured your check_user
# properly or these commands will not work for you.

require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class ControlPanel
    include Cinch::Plugin
    include Cinch::Helpers
    
    # The die function forces the bot to quit irc and end it's process upon execution.

    match /die/, method: :execute_die
	
	def execute_die(m)
	  if m.channel
	    unless check_user(m.user)
          m.reply Format(:red, "You are not authorized to use this command! This incident will be reported.")
          bot.info("Received invalid quit command from #{m.user.nick}")
        return;
	    end
        bot.info("Received valid quit command from #{m.user.nick}")
        m.reply Format(:green, "Very well. Goodbye.")
        bot.quit("on command of #{m.user.nick}")
      end
    end
      
    # This is to set autovoice on/off and to execute based on whether it is on
    # or not. It listens for a join and then automatically gives the joined 
    # user voice if autovoice is set to ON.
      
    listen_to :join
  
    match /autovoice (on|off)$/, method: :execute_av

  def listen(m)
    unless m.user.nick == bot.nick
      m.channel.voice(m.user) if @autovoice
    end
  end

  def execute_av(m, option)
    if m.channel
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported.")
        bot.info("Received invalid autovoice command from #{m.user.nick} in #{m.channel}")
      return;
    end
      unless check_ifban(m.user)
        @autovoice = option == "on"
        m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
        bot.info("Received valid autovoice command from #{m.user.nick} in #{m.channel}")
      end
    end
  end
  
# The following command will cause the bot to join or part
# a channel as directed. Please bear in mind that at this
# time there are no limiters on how many times this can 
# be used in any given timeframe, so only add users to
# check_user that can be trusted not to give Eve or 
# yourself a bad reputation!
  
    match /join (.+)/, method: :join
    match /part(?: (.+))?/, method: :part

  def join(m, channel)
    if m.channel
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid join command from #{m.user.nick} in #{m.channel}")
      return;
	  end
        Channel(channel).join
        bot.info("Received valid join command from #{m.user.nick} in #{m.channel}")
      end
    end


  def part(m, channel)
    if m.channel
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid part command from #{m.user.nick} in #{m.channel}")
      return;
    end
        channel ||= m.channel
        Channel(channel).part if channel
        bot.info("Received valid part command from #{m.user.nick} in #{m.channel}")
      end
    end
    
  # Now we are going to go into commands that should be used in a query with the bot.
  
# This command will cause Eve to send a message to the 
# channel that you ask her to. Please bear in mind that
# there is no announcement other than in the console 
# that someone is making Eve say these things so please
# use caution when adding users to check_user!
  
    set :prefix, /^./
	  
    match /say (#.+?) (.+)/
	  
  def execute(m, receiver, message)
    unless check_user(m.user)
      m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
      bot.info("Received invalid say command from #{m.user.nick}")
    return;
	end
      Channel(receiver).send(message)
      bot.info("Received valid say command from #{m.user.nick}")
    end
    
# The following command acts the same as the one above
# however it sends the equivalent of /me to the channel
# instead of a message.
    
    set :prefix, /^./
    
    match /act (.+?) (.+)/, method: :execute_act
  
  def execute_act(m, receiver, act)
    unless check_user(m.user)
      m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
      bot.info("Received invalid act command from #{m.user.nick}")
    return;
  end
      Channel(receiver).action(act)
      bot.info("Received valid act command from #{m.user.nick}")
    end
    
# The following command has Eve send a specified message
# to NickServ. This command can be used just like /ns 
# can be used on your client, so there are a vast array
# of things that can be done with this command!
    
    set :prefix, /^./
    
    match /ns (.+?) (.+)/, method: :execute_ns
    
  def execute_ns(m, text)
    unless check_user(m.user)
      m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
      bot.info("Received invalid ns command from #{m.user.nick}")
    return;
  end
      User("nickserv").send(text)
      bot.info("Received valid ns command from #{m.user.nick}")
    end
    
    set :prefix, /^./
    
# The following command does the same as the one above,
# however it allows you to use ChanServ instead!
    
    match /cs (.+?) (.+)/, method: :execute_cs
    
  def execute_cs(m, text)
    unless check_user(m.user)
      m.reply Format(:red, "You are not authorized to use this command! This incident will be reported")
      bot.info("Received invalid cs command from #{m.user.nick}")
    return;
  end
      User("chanserv").send(text)
      bot.info("Received valid cs command from #{m.user.nick}")
    end
  end
end

# A FEW NOTES:
# 1.) If you need further help with the commands and their syntax just type !help in a channel
# that Eve is in and she will send you a vast array of commands at your disposal.
#
# As a last note, always remember that EVE is a project for a Top-Tier IRC bot, and the project
# could always use more help. Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at rawr.coreirc.org