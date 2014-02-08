	

    require 'cinch'
    require 'ostruct'
    require 'open-uri'
    require 'json'
    require 'cgi'
     
    module Cinch
      module Plugins
        class FourChan
          include Cinch::Plugin
         
          set :prefix, /^~/
             
          match /4chan (.+) (.+)/

         
          def execute(m, board, query)
            data = search(m, board, query)
            return m.reply "No results found for #{query}." if data.nil?
            search_result(m, data)
          end
       
          def search(m, board, terms)
            chan_logo = "3::5 4chan:"
            data = JSON.parse(open("https://api.4chan.org/#{board}/catalog.json").read)
            results = []
            
         
            for i in data
              for j in i['threads']
                subject   = j['sub']
                comment   = j['com']
                replies   = j['replies']
                images    = j['images']
                id        = j['no']
                
             
                if subject == nil
                  subject = "No subject"
                end
     
                if comment == nil
                  comment = "No comment"
                end
                
                comment_s = CGI.unescape_html(comment).gsub( %r{</?[^>]+?>}, ' ' )
                comment_s = comment_s[0..200] # We need to limit the characters for 4chan comments
                
                if subject.downcase.include? terms.downcase or comment.downcase.include? terms.downcase
                  results.push("%s /#{board}/ %s - %s (R:%s | I:%s) [ https://boards.4chan.org/#{board}/res/%s ]" % [chan_logo, subject, comment_s, replies, images, id])
                end
              end
            end
          return results
          end
     
       
          def search_result(m, data)
            data[0..2].each{|i| m.reply i}
          end
        end
      end
    end
