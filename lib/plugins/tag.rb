require 'cinch'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Tag
      include Cinch::Plugin

      set :plugin_name, 'tag'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      You can use the bot to play a game of tag!
      Usage:
      * !tag start: Start a game of tag in the channel that the command is invoked in.
      * !tag <user>: Tag a user and they become 'it'.
      * !tag quit: End the game of tag.
      USAGE

      match /tag start/, method: :start

      def start(m)
	return if check_ignore(m.user)

	if @toggle == 'on'
	  nick = User(@it).nick

	  m.reply "I'm sorry, there is already a game going on right now. #{nick} is it!"
	  return
	end
	@toggle = 'on'
	@it = m.user.nick.downcase

	nick = User(@it).nick

	m.reply "New tag game started! #{nick} is it!"
      end

      match /tag (.+)/, method: :tag

      def tag(m, target)
	return if check_ignore(m.user)

	return m.reply "You can't tag yourself, #{m.user.nick}!" if target == m.user.nick

	return if target == "start"

	return if target == "quit"

	unless @toggle == 'on'
	  m.reply "There is no tag game going on right now, #{m.user.nick}!"
	  return
	end
	if @it
	  unless @it == m.user.nick.downcase
	    m.reply "#{m.user.nick} you are not it!"
	    return
	  end
	  unless Channel(m.channel).users.keys.include?(target)
	    m.reply "I'm sorry #{m.user.nick}, but #{target} is not in this channel!"
	    return
	  end
	  nick   = User(target).nick

	  target = target.downcase
	  @it = target
	  m.reply "#{m.user.nick} has tagged #{nick}. #{nick} is now it!"
	  return
	else
	  m.reply "I'm sorry, but you are not it, #{m.user.nick}!"
	end
      end

      match /tag quit/, method: :quit

      def quit(m)
	return if check_ignore(m.user)

	unless @toggle == 'on'
	  m.reply "There is no game going on right now, #{m.user.nick}!"
	  return
	end
	if @it
	  @toggle = 'off'
	  @it = nil
	  m.reply "This tag game is over! Time to go home now!"
	  return
	end
      else
	m.reply "There is no currently active game!"
      end
    end
  end
end


