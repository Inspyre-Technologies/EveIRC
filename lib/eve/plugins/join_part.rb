require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class JoinPart
    include Cinch::Plugin
    include Cinch::Helpers

    match /join (.+)/, method: :join
    match /part(?: (.+))?/, method: :part

  def join(m, channel)
    if m.channel
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command!")
      return;
	  end
        Channel(channel).join
      end
    end


  def part(m, channel)
    if m.channel
      unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command!")
      return;
    end
        channel ||= m.channel
        Channel(channel).part if channel
      end
    end
  end
end
