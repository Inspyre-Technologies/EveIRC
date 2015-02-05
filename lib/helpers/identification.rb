module Cinch
  module Helpers
    
    def check_method(user)
      if user.is_a?(String)
        nick = user
      else
        nick = user.nick
      end
      if ((@masterFile.key?(nick)) && (@masterFile[nick].key? 'authentication'))
        method   = @masterFile[nick]['authentication']
        failsafe = @masterFile[nick]['failsafe']
        if ( (method == "NS") && (failsafe == false) )
          return method = "NS"
        end
        if ( (method == "NS") && (failsafe == true) )
          return method = "nsFS"
        end
        if ( (method == "2FA") && (@masterFile[nick].key? '2fa-pass'))
          return method = "2FA"
        end
        if ( (method == "PASS") && (failsafe == false) )
          return method = "PASS"
        end
        return method = "There's a problem"
      end
      method = "User not found"
    end
    
    def login_2fa(user, pass)
      if user.is_a?(String)
        return false
      else
        user.refresh
        return false unless !user.authname.nil?
        authname  = user.authname
        rAuthname = @masterFile[user.nick]['authname']
        return false unless authname.downcase == rAuthname
        stored = @masterFile[User(user).nick]['2fa-pass']
        sPass  = BCrypt::Password.new(stored)
        return false unless sPass == pass
      end
      return true
    end
    
    def login_pass(user, pass)
      if user.is_a?(String)
        nick = user
      else
        nick = user.nick
      end
      stored = @masterFile[nick]['master-pass']
      sPass  = BCrypt::Password.new(stored)
      return false unless sPass == pass
      return true
    end
    
    def login_nsFS(m, target, pass)
      if !User(m.user).authname.nil?
        authname  = User(m.user).authname.downcase
        rAuthname = @masterFile[User(m.user).nick]['authname']
        return "ns" if authname == rAuthname
      end
      if User(m.user).authname.nil?
        stored = @masterFile[target]['fsPass']
        sPass  = BCrypt::Password.new(stored)
        return false unless sPass == pass
        return "fs"
      end
    end
  end
end