require 'cinch'
require_relative "config/check_user"

module Cinch::Plugins
  class AIRespond
  include Cinch::Plugin
  include Cinch::Helpers
  
    def status(m)
      [
        "I'm a bot #{m.user.nick}, how do you think I am?",
        "I'm le tired. All I do is sit here and do as I'm told #{m.user.nick}!",
        "I'm okay. How are you #{m.user.nick}?"
      ].sample
    end
	
    def hir(m)
      [
        "Hello #{m.user.nick}",
        "Hey there #{m.user.nick}!",
        "Greetings #{m.user.nick}, I'm ready to serve!"
      ].sample
    end
    
	def brbr(m)
      [
        "Hurry back #{m.user.nick}",
        "Don't threaten us #{m.user.nick}!",
        "I won't wait up #{m.user.nick}!"
      ].sample
    end
  
  set :prefix, /^^/
  match lambda {|m| /#{m.bot.nick}, how are you/}, :method => :hau
  match lambda {|m| /#{m.bot.nick} how are you/}, :method => :hau
  match lambda {|m| /How are you, #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /How are you #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /how are you, #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /how are you #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /how are you doing, #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /how are you doing #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /How are you doing #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /How are you doing, #{m.bot.nick}/}, :method => :hau
  match lambda {|m| /Hello #{m.bot.nick}./}, :method => :hi
  match lambda {|m| /Hello, #{m.bot.nick}./}, :method => :hi
  match lambda {|m| /Hello, #{m.bot.nick}!/}, :method => :hi
  match lambda {|m| /hello #{m.bot.nick}!/}, :method => :hi
  match lambda {|m| /hello, #{m.bot.nick}!/}, :method => :hi
  match lambda {|m| /hello, #{m.bot.nick}./}, :method => :hi
  match lambda {|m| /hello #{m.bot.nick}./}, :method => :hi
  match lambda {|m| /hello #{m.bot.nick}/}, :method => :hi
  match lambda {|m| /Hello #{m.bot.nick}/}, :method => :hi
  match /brb/, :method => :brb
  
    def hau(m)
	  m.reply status(m)
	end
	
	def hi(m)
	  m.reply hir(m)
	end
	
	def brb(m)
	  m.reply brbr(m)
	end
  end
end
