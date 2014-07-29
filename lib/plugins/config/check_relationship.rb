require 'cinch'
require 'yaml'

module Cinch
  module Helpers
    
    def check_foe(user)
      reload
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'foe'))
        foe = @storage[user.nick]['foe']
        return foe
      end
    end
    
    def check_friend(user)
      reload
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'friend'))
        friend = @storage[user.nick]['friend']
        return friend
      end
    end
    
    def check_bff(user)
      reload
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'bff'))
        bff = @storage[user.nick]['bff']
        return bff
      end
    end
    
    def reload
      if File.exist?('docs/userinfo.yaml')
      @storage = YAML.load_file('docs/userinfo.yaml')
      else
        @storage = {}
      end
    end
  end
end
