module Cinch
  module Helpers
  
    def check_foe(user)
    
      %w[foo bar].include? user.nick
    end
end
end