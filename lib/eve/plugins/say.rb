module Cinch
  module Plugins
    class Say
      include Cinch::Plugin
      include Cinch::Helpers
	  
      set :prefix, /^./
	  
      match /say (.+?) (.+)/
	  
	  def execute(m, receiver, message)
	    unless check_user(m.user)
        m.reply Format(:red, "You are not authorized to use this command!")
      return;
	  end
        Channel(receiver).send(message)
      end
    end
  end
end
