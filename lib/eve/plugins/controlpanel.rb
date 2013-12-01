# This is the control panel for Eve. Most of the commands you'll use as an admin will
# run off of this plugin. Please make sure that you've configured your check_user
# properly or these commands will not work for you.

require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class ControlPanel
    include Cinch::Plugin
    include Cinch::Helpers
    
    set :plugin_name, 'controlpanel'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      Allows you to control the basic functions of the bot.
      Usage:
      - !die: Forces the bot to die. Please keep in mind that you can't start it up again without shell access.
      - !autovoice [<on>|<off>]: This command turns autovoice on and off. Autovoice forces the bot to give +v to everyone who joins that channel.
      - !join <channel>: This will force the bot to join a channel.
      - !part [<channel>]: This will force the bot to part a channel. Note: if you do not specify a channel it will part the channel in which the command is invoked..
      USAGE
    
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
        @autovoice = option == "on"
        m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
        bot.info("Received valid autovoice command from #{m.user.nick} in #{m.channel}")
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