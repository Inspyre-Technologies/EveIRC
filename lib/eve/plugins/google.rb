	

    require 'cinch'
    require 'ostruct'
    require 'open-uri'
    require 'json'
     
    module Cinch
      module Plugins
        class Google
          include Cinch::Plugin
       
          match /google (.+)/, method: :execute
     
       
        def execute(m, query)
          data = search(m, query)
          return m.reply "No results found for #{query}." if data.nil?
          search(m, terms)
        end
       
        def search(m, terms)
          data = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{terms}").read)
          rdata = data['responseData']
          results = rdata['results']
          results1 = results[0]
          results1t = results1['titleNoFormatting']
          results1u = results1['unescapedUrl']
          m.reply Format(:green, "#{results1t} [#{results1u}]")
          rescue
            nil
          end
        end
      end
    end

