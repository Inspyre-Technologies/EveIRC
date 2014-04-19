require 'cinch'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Fun
    include Cinch::Plugin
    
    match /revive (.+)/i, method: :revive
    
  def revive(m, user)
    return if check_ignore(m.user)
    if User(user) == m.bot
      samebot(m, user)
    return;
  end
    if m.channel.users.has_key?(User(user)) == false
      notinchan(m, user)
    return;
  end
    if User(user) == m.user
      itsyou(m, user)
    return;
  end
      sleep config[:delay] || 3
      m.channel.action "throws a Phoenix Down on #{User(user).nick}, effectively reviving them!"
    end

  
  def samebot(m, user)
    sleep config[:delay] || 3
    m.reply Format(:green, "That's me!")
  end

  def notinchan(m, user)
    sleep config[:delay] || 3
    m.reply Format(:green, "#{user} isn't in the channel")
  end
  
  def itsyou(m, user)
    sleep config[:delay] || 3
    m.reply Format(:green, "That's you!")
  end
end
end
end
