require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class AutoVoice
    include Cinch::Plugin
    include Cinch::Helpers
    listen_to :join
  
  match /autovoice (on|off)$/

  def listen(m)
    unless m.user.nick == bot.nick
      m.channel.voice(m.user) if @autovoice
    end
  end

  def execute(m, option)
    if m.channel
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command!")
      return;
    end
      unless check_ifban(m.user)
          @autovoice = option == "on"
          m.reply "Autovoice is now #{@autovoice ? 'enabled' : 'disabled'}"
        end
      end
    end
  end
end