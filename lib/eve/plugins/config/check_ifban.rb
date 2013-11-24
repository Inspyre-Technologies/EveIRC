module Cinch
  module Helpers
  
  def check_ifban(user)
    user.refresh
	
	  if %w[troll].include? user.authname
	    user.send Format(:red, "You are banned from using my functions!")
      end
	end
  end
end