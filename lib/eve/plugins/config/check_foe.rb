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
      
    def check_foe(user)
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'foe'))
        foe = @storage[user.nick]['foe']
        return foe
      end
    end
  end
end