require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'

module Cinch
  module Plugins
    class Google
      include Cinch::Plugin
       
      set :prefix, /^~/
       
      match /google (.+)/, method: :execute_w
      match /images (.+)/, method: :execute_i
      
    def execute_w(m, query)
      query.gsub! /\s/, '+'
      data = search_w(m, query)
      return m.reply "No results found for #{query}." if data.nil?
      search_result_w(m, data)
    end
    
    def execute_i(m, query)
      query.gsub! /\s/, '+'
      data = search_i(m, query)
      return m.reply "No results found for #{query}." if data.nil?
      search_result_i(m, data)
    end
    
    def search_w(m, terms)
      data = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{terms}").read)
      rdata = data['responseData']
      results = rdata['results']
      results1 = results[0]
      results2 = results[1]
      results3 = results[2]
      
      OpenStruct.new(
        title1:      results1['titleNoFormatting'],
        url1:        results1['unescapedUrl'],
        
        title2:      results2['titleNoFormatting'],
        url2:        results2['unescapedUrl'],
        
        title3:      results3['titleNoFormatting'],
        url3:        results3['unescapedUrl']
      )
      rescue
        nil
      end
      
    def search_i(m, terms)
      data = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{terms}").read)
      rdata = data['responseData']
      results = rdata['results']
      results1 = results[0]
      results2 = results[1]
      results3 = results[2]
      
      OpenStruct.new(
        width1:      results1['width'],
        height1:     results1['height'],
        url1:        results1['unescapedUrl'],
        
        width2:      results2['width'],
        height2:     results2['height'],
        url2:        results2['unescapedUrl'],
        
        width3:      results3['width'],
        height3:     results3['height'],
        url3:        results3['unescapedUrl']
      )
      rescue
        nil
      end
         
        def search_result_w(m, data)
          m.reply Format(:green, "%s%s%s%s%s%s: #{data.title1} [ #{data.url1} ]" % [Format(:blue, "G"), Format(:red, "o"), Format(:yellow, "o"), Format(:blue, "g"), Format(:green, "l"), Format(:red, "e")])
          m.reply Format(:green, "%s%s%s%s%s%s: #{data.title2} [ #{data.url2} ]" % [Format(:blue, "G"), Format(:red, "o"), Format(:yellow, "o"), Format(:blue, "g"), Format(:green, "l"), Format(:red, "e")])
          m.reply Format(:green, "%s%s%s%s%s%s: #{data.title3} [ #{data.url3} ]" % [Format(:blue, "G"), Format(:red, "o"), Format(:yellow, "o"), Format(:blue, "g"), Format(:green, "l"), Format(:red, "e")])
        end
        
        def search_result_i(m, data)
          m.reply Format(:green, "%s%s%s%s%s%s: #{data.title1} [ #{data.url1} ]" % [Format(:blue, "I"), Format(:red, "m"), Format(:yellow, "a"), Format(:blue, "g"), Format(:green, "e"), Format(:red, "s")])
          m.reply Format(:green, "%s%s%s%s%s%s: #{data.title2} [ #{data.url2} ]" % [Format(:blue, "I"), Format(:red, "m"), Format(:yellow, "a"), Format(:blue, "g"), Format(:green, "e"), Format(:red, "s")])
          m.reply Format(:green, "%s%s%s%s%s%s: #{data.title3} [ #{data.url3} ]" % [Format(:blue, "I"), Format(:red, "m"), Format(:yellow, "a"), Format(:blue, "g"), Format(:green, "e"), Format(:red, "s")])
        end        
      end
    end
  end