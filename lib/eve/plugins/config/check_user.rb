module Cinch
  module Helpers
  
  def check_user(user)
    user.refresh
	
	%w[foo bar you].include? user.authname
  end
end
end
