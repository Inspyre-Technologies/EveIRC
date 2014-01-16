module Cinch
  module Helpers
  
    def check_friend(user)
    
      %w[foo bar].include? user.nick
    end
end
end