require 'cinch'
require 'yaml'

module Cinch
  module Helpers
      
    def check_friend(user)
      reload
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'friend'))
        friend = @storage[user.nick]['friend']
        return friend
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