require 'cinch'
require 'yaml'

module Cinch
  module Helpers
  
    def initialize(*args)
      super
        if File.exist?('userinfo.yaml')
          @storage = YAML.load_file('userinfo.yaml')
        else
          @storage = {}
        end
      end
      
    def check_friend(user)
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'friend'))
        friend = @storage[user.nick]['friend']
        return friend
      end
    end
  end
end