require 'cinch'
require_relative "config/check_master"

module Cinch::Plugins
  class PrivChanCP
    include Cinch::Plugin
    include Cinch::Helpers
    set :react_on, :private
    
    set :prefix, /^~/
    set :plugin_name, 'privchancp'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      Private commands to allow you to control the channel functions of the bot.
      Usage:
      - ~kick <channel> <nick> [<reason>]: This command must be used in a PM. Forces the bot to kick the specified user from the specified channel. Note: if you do not give a <reason> the bot will not give one either.
      - ~ban <channel> <nick>: This command must be used in a PM. Forces the bot to ban the specified user from the specified channel.
      - ~unban <channel> <mask>: This command must be used in a PM. Forces the bot to unban a specified mask in the specified channel. Note: you must specify the mask or the bot can not unban the user.
      - ~kban <channel> <nick> <reason>: This command must be used in a PM. Forces the bot to kick and ban the specified user from the specified channel with the specified reason. Note: if you do not specify the reason, the bot won't either.
      - ~op <channel> <nick>: This command must be used in a PM. Forces the bot to op the specified user in the specified channel.
      - ~deop <channel> <nick>: This command must be used in a PM. Forces the bot to deop the specified user in the specified channel.
      - ~voice <channel> <nick>: This command must be used in a PM. Forces the bot to give the specified user voice in the specified channel.
      - ~devoice <channel> <nick>: This command must be used in a PM. Forces the bot to take voice from the specified user in the specified channel.
      - ~topic <channel> <topic>: This command must be used in a PM. Forces the bot to change the topic in the specified channel to the topic you specify.
      USAGE
    
    # This will kick the user. This is nice if you're a nice admin and
    # don't want to be seen kicking your friends for being n00bs! :p
    
    def initialize(*args)
      super
        if File.exist?('userinfo.yaml')
          @storage = YAML.load_file('userinfo.yaml')
        else
          @storage = {}
        end
      end
    
    match /kick (#\S+) (\S+)\s?(.+)?/, method: :execute_kick
    
    def execute_kick(m, channel, knick, reason)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid kick command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kick' command for #{channel} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kick' command for #{channel} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't make a kick because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kick' command for #{channel} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).users.keys.include?(knick)
        m.reply ("I can not kick #{knick} because #{knick} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kick' command to kick #{knick} from #{channel} but #{knick} is not in #{channel}.") }
      return;
    end
        bot.info("Received valid kick command from #{m.user.nick}")
        m.reply Format(:green, "Very well...")
        Channel(channel).kick(knick, reason)
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'kick' command to kick #{knick} from #{channel}. Reason: #{reason}") }
      end
    
    # The nice thing about the following command is that it takes the nick
    # that EVE is given and converts it into a ban-able mask. There is 
    # nothing I hate more as a chanop than having to copy paste the mask
    # when a user is flooding or suffer the consequences of banning only
    # the nick which can be easily evaded by a nick change.
  
    match /ban (#\S+) (\S+)/, method: :execute_ban
  
    def execute_ban(m, channel, user)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid ban command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'ban' command for #{channel} on #{user} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'ban' command for #{channel} on #{user} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't ban #{user} because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'ban' command for #{channel} on #{user} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).users.keys.include?(user)
        m.reply ("I can not ban #{user} because #{user} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'ban' command to ban #{user} from #{channel} but #{user} is not in #{channel}.") }
      return;
    end
      bot.info("Received valid ban command from #{m.user.nick}")
      user = User(user)
      mask = user.mask("*!*@%h")
      m.reply Format(:green, "Very well...")
      Channel(channel).ban(mask)
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'ban' command in #{channel} on #{user}. Banned mask: #{mask}") }
    end
    
    # Sometimes you just have to unban a fella! Unfortunately now you have
    # to do the work of defining the mask for the bot to unban. D:
    
    match /unban (#\S+) (\S+)/, method: :execute_unban
  
    def execute_unban(m, channel, mask)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid unban command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'unban' command for #{channel} on #{mask} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'unban' command for #{channel} on #{mask} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't unban #{mask} because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'unban' command for #{channel} on #{mask} but I am not op in #{channel}.") }
      return;
    end
      bot.info("Received valid unban command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      Channel(channel).unban(mask)
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'unban' command to unban #{mask} from #{channel}.") }
    end
    
    # What better way to make your point but to kick and ban the annoying 
    # user at the same time! This instance just combines the ban and kick
    # instances together to create one nice smooth package.
    
    match /kban (#\S+) (\S+)(?: (.+))?/, method: :execute_kban
    
    def execute_kban(m, channel, user, reason)
      unless check_master(m.user)
        sleep config[:delay] || 10
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid kban command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kban' command for #{channel} on #{user} but was not authorized.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't kban #{user} because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kban' command for #{channel} on #{user} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).users.keys.include?(user)
        m.reply ("I can not kick/ban #{user} because #{user} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'kban' command to kick/ban #{user} from #{channel} but #{user} is not in #{channel}.") }
      return;
    end
      bot.info("Received valid kban command from #{m.user.nick}")
      user = User(user)
      mask = user.mask("*!*@%h")
      m.reply Format(:green, "Very well...")
      Channel(channel).ban(mask)
      Channel(channel).kick(user, reason)
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'kban' command to kick and ban #{user} from #{channel}. Reason: #{reason} | Banned mask: #{mask}") }
    end
    
    # Why not? 
    
    match /op (#\S+) (\S+)(?: (.+))?/, method: :execute_rop
    
    def execute_rop(m, channel, user)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid op command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'op' command for #{channel} on #{user} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'op' command for #{channel} on #{user} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't op #{user} because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'op' command for #{channel} on #{user} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(user) == false
        m.reply ("I can't op #{user} because they already have op in #{channel} Perhaps you meant to use the 'deop' command?")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'op' command for #{channel} on #{user} but #{user} already has op in #{channel}") }
      return;
    end
      unless Channel(channel).users.keys.include?(user)
        m.reply ("I can not op #{user} because #{user} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'op' command to op #{user} in #{channel} but #{user} is not in #{channel}.") }
      return;
    end
      bot.info("Received valid op command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} +o #{user}")
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'op' command to give +o to #{user} in #{channel}.") }
    end
    
    # This is for when you need to deop, duh! :P
    
    match /deop (#\S+) (\S+)(?: (.+))?/, method: :execute_rdop
    
    def execute_rdop(m, channel, user)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid deop command from #{m.user.nick}. User attempted to op #{user} in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'deop' command for #{channel} on #{user} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'deop' command for #{channel} on #{user} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't deop #{user} because I am not op in #{channel}")
        bot.info("Valid deop command failed because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'deop' command for #{channel} on #{user} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't deop #{user} because #{user} does not have op in #{channel}. Perhaps you meant to use the 'op' command?")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'deop' command for #{channel} on #{user} but #{user} does not have op in #{channel}.") }
      return;
    end
      unless Channel(channel).users.keys.include?(user)
        m.reply ("I can not deop #{user} because #{user} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'deop' command to deop #{user} in #{channel} but #{user} is not in #{channel}.") }
      return;
    end
      bot.info("Received valid deop command from #{m.user.nick} for #{channel}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} -o #{user}")
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'op' command to take +o from #{user} in #{channel}.") }
    end
    
    # This mode (voice) is becoming obsolete. But why not add it to the 
    # list anyway?
    
    match /voice (#\S+) (\S+)(?: (.+))?/, method: :execute_rv
    
    def execute_rv(m, channel, user)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid voice command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'voice' command for #{channel} on #{user} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'voice' command for #{channel} on #{user} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't give voice to #{user} because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'voice' command for #{channel} on #{user} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).users.keys.include?(user)
        m.reply ("I can not voice #{user} because #{user} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'voice' command to voice #{user} in #{channel} but #{user} is not in #{channel}.") }
      return;
    end
      bot.info("Received valid voice command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} +v #{user}")
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'voice' command to give +v to #{user} in #{channel}.") }
    end
    
    # We can take it away just as easily!
    
    match /devoice (#\S+) (\S+)(?: (.+))?/, method: :execute_rdv
    
    def execute_rdv(m, channel, user)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid devoice command from #{m.user.nick}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'devoice' command for #{channel} on #{user} but was not authorized.") }
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'devoice' command for #{channel} on #{user} but I am not in #{channel}.") }
      return;
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't take voice from #{user} because I am not op in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'devoice' command for #{channel} on #{user} but I am not op in #{channel}.") }
      return;
    end
      unless Channel(channel).users.keys.include?(user)
        m.reply ("I can not devoice #{user} because #{user} is not in #{channel}")
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'devoice' command to devoice #{user} in #{channel} but #{user} is not in #{channel}.") }
      return;
    end
      bot.info("Received valid devoice command from #{m.user.nick}")
      m.reply Format(:green, "Very well...")
      bot.irc.send ("MODE #{channel} -v #{user}")
      Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'devoice' command to take +v from #{user} in #{channel}.") }
    end
    
    # This could be fun and particularly useful in your channel if you set
    # funny (and embarrassing) quotes from users in your topic. They won't
    # know it's you!
    
    match /t (#.+?) (.+)/, method: :execute_topic
    
    def execute_topic(m, channel, topic)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use this command! This incident will be reported!")
        bot.info("Received invalid topic command from #{m.user.nick}")
      return;
    end
      unless bot.channels.include? Channel(channel)
        m.reply ("I'm sorry. I am not in #{channel}, please have me join that channel and op me in order for me to complete this action!")
      return
    end
      unless Channel(channel).opped?(m.bot) == true
        m.reply ("I can't change the topic in #{channel} because I am not op.")
      return;
    end
      puts topic
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
# 2.) Please remember that these commands can be easily abused and you don't want to give the wrong
# impression to chanops or IRCops, so please use with caution and permission. Also, don't add anyone
# who doesn't have the common sense to do the same.
#
# As a last note, always remember that EVE is a project for a Top-Tier IRC bot, and the project
# could always use more help. Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at rawr.coreirc.org