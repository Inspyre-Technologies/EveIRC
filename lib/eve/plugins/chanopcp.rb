require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class ChanopCP
    include Cinch::Plugin
    include Cinch::Helpers
  
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
    
    set :prefix, /^./
    
    match /kick (#\S+) (\S+)\s?(.+)?/, method: :execute_kick
    
    def execute_kick(m, channel, knick, reason)
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid kick command from #{m.user.nick}")
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
  end
end