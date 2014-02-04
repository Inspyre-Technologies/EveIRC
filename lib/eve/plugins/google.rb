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
        search_result(m, data)
      end
    
      def execute_i(m, query)
        query.gsub! /\s/, '+'
        data = search_i(m, query)
        return m.reply "No results found for #{query}." if data.nil?
        search_result(m, data)
      end
    
      def search_w(m, terms)
        logo = "12G4o8o12g9l4e"
        data = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{terms}").read)
        rdata = data['responseData']['results']
        results = []
      
        rdata.each{|i| results.push("%s: %s [ %s ]" % [logo, i['titleNoFormatting'], i['unescapedUrl']])}
      
        return results
      end
      
      def search_i(m, terms)
        logo = "12I4m8a12g9e4s"
        data = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{terms}").read)
        rdata = data['responseData']['results']
        results = []
        
        rdata.each{|i| results.push("%s: %s (%sx%s)" % [logo, i['unescapedUrl'], i['width'], i['height']])}
        
        return results
      end
       
      def search_result(m, data)
        data[0..2].each{|i| m.reply i}
      end
      
    end
  end
end
