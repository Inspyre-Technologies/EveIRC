# This is the channel control panel for Eve. Most of the commands you'll
# use as an admin will run off of this plugin. Please make sure 
# that you've configured your check_master properly or these commands will
# not work for you. TAKE NOTE: I don't want you to gain a bad reputation
# for yourself or for Eve, so please remember that these commands can be
# abused and are likely to be abused if you don't take caution with who
# you are adding to check_master!

require 'cinch'
require_relative "config/check_master"

module Cinch::Plugins
  class ChanopCP
    include Cinch::Plugin
    include Cinch::Helpers
    
    # First we will address everything that your users will need to know
    # in order to use EVE. Feel free to edit anything between the "usage"
    # tags, as long as it's sane to your users. :P
    
    set :plugin_name, 'chanopcp'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      Allows you to control the channel functions of the bot. The bot must have op in the specified channels or these commands will not work! Please keep in mind that all uses of these commands are reported on the console!
      Usage:
      - !opme: This command must be used in a channel. Forces the bot to op you.
      - !deopme: This command must be used in a channel. Forces the bot to deop you.
      USAGE
    
    # Now that we have that out of the way we are going to jump right in 
    # to the meat of the plugin. The following instance is used to op the
    # command giver in the channel he's using it. We should make these
    # fool-proof so as to discourage newer users from bugging you for help.
    #
    # That is why you will see several methods for telling the user what
    # they are doing wrong. If the bot isn't opped, they don't have rights
    # etc, etc.
    #
    # TODO: Add a method for determining whether the bot is in the channel
    # that it's being asked to execute in!
    
      def initialize(*args)
        super
          if File.exist?('docs/userinfo.yaml')
            @storage = YAML.load_file('docs/userinfo.yaml')
          else
            @storage = {}
          end
        end
    
    match /opme/, method: :execute_op
  
    def execute_op(m)
      if m.channel
        unless check_master(m.user)
          m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported!")
          bot.info("Received invalid OpMe command from #{m.user.nick}")
          Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'opme' command in #{m.channel} but was not authorized.") }
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
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'opme' command in #{m.channel} to op themselves!") }
      end
    end
    
    # It's only sane to add an instance to undo the last, we mustn't become
    # lazy here!
    
    match /deopme/, method: :execute_deop
    
    def execute_deop(m)
      if m.channel
        unless check_master(m.user)
          m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported!")
          bot.info("Received invalid deopme command from #{m.user.nick}")
          Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'deopme' command in #{m.channel} but was not authorized.") }
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
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'deopme' command in #{m.channel} to deop themselves!") }
      end
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