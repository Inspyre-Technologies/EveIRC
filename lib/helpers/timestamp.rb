module Cinch
  module Helpers
    
#    A simple method to retrieve a timestamp for logging
    def timestamp
      return Time.now.strftime("[ %Y/%m/%d %H:%M:%S.%L ]")
    end
  end
end
