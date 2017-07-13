# Author: Richard Banks
# Author: b0nk
# E-Mail: namaste@rawrnet.net

# This is your standard Google search plugin using the JSON API that Google
# provides. Please keep in mind that it can be a little spammy due to it
# providing the top three results of the query.

require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'cgi'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Google
      include Cinch::Plugin
      
      set :plugin_name, 'google'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Use this plugin to search Google for a webpage or image.
        !google <query>: Searches for <query>. You can optionally use the -image or -i flag to search for images.
      USAGE
      
      
      APIKEY = config[:key]
      
      ENGINEID = config[:engineid]
      
      match /google( -image| -i)? (.+)/i
      
      # Execute the web search.
      def execute(m, type, query)
        return if check_ignore(m.user)
        query.gsub! /\s/, '+'
        
        case type
        when " -image", " -i"
          type = "image"
        else
          type = "web"
        end
        
        data = lookup(m, type, query)
        return m.reply "No results found for #{query}." if data.empty?
        result(m, data)
      end
      
      def lookup(m, type, query)
        
        case type
        when "image"
          logo = "12I4m8a12g9e4s"
          data = JSON.parse(open("https://www.googleapis.com/customsearch/v1?q=#{query}&cx=#{ENGINEID}&num=3&searchType=image&key=#{APIKEY}").read)
        else
          logo = "12G4o8o12g9l4e"
          data = JSON.parse(open("https://www.googleapis.com/customsearch/v1?q=#{query}&cx=#{ENGINEID}&num=3&key=#{APIKEY}").read)
        end
        
        data = data['items']
        results = []
        
        for i in data
          title = i['title']
          title = title[0..100]
          if type == "web"
            snippet = i['snippet']
            snippet = snippet[0..50]
          end
          link = i['link']
          if type == "image"
            height = i['image']['height']
            width  = i['image']['width']
            size   = i['image']['byteSize']
          end
          
          case type
          when "web"
            results.push("%s |-| Title: %s |-| %s |-| %s" % [logo, title, snippet, link])
            
          when "image"
            results.push("%s |-| Image Title: %s |-| Size: %s x %s |-| File Size: %sbytes |-| %s" % [logo, title, width, height, size, link])
          end
        end
        return results
      end
      
      def result(m, data)
        data[0..2].each{|i| m.reply i}
      end
    end
  end
end

## Written by Richard Banks for Eve-Bot "The Project for a Top-Tier IRC bot.
## E-mail: namaste@rawrnet.net
## Github: Namasteh
## Website: www.rawrnet.net
## IRC: irc.sinsira.net #Eve
## If you like this plugin please consider tipping me on gittip
