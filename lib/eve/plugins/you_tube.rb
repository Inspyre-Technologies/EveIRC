    require 'cinch'
    require 'open-uri'
    require 'nokogiri'
    require 'cgi'
    require_relative "config/check_ignore"
     
    module Cinch
      module Plugins
        class YouTube
          include Cinch::Plugin
         
          match /youtube (.+)/
         
          def execute(m, query)
            return if check_ignore(m.user)
            query.gsub! /\s/, '+'
            data = lookup(m, query)
            return m.reply "No results found for #{query}." if data.empty?
            result(m, data)
          end
         
          def lookup(m, terms)
                yt_logo = "0,4You1,0Tube"
                    query = URI::encode(terms)
            doc = Nokogiri::XML(open("https://gdata.youtube.com/feeds/api/videos?q=%s" % query))
            info = doc.css("entry")
                results = []
             
                for i in info
                  title = i.css("title").inner_text()
                  content = i.css("content").inner_text()
                  author = i.css("author").css("name").inner_text()
                  url = i.css("id").inner_text().split("/")[-1]
         
                  results.push("%s 3Title: %s | %s | By: %s | http://youtu.be/%s" % [yt_logo, title, content, author, url])
            end
             
          return results
          end
         
          def result(m, data)
                data[0..2].each{|i| m.reply i}
          end  
        end
      end
    end

