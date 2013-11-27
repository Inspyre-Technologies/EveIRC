require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

# This plugin searches Urban Dictionary and prints the result to the IRC
# channel. 

module Cinch::Plugins
  class UrbanDictionary
    include Cinch::Plugin

    match /urban (.+)/
    
    def lookup(word)
      url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(word)}"
      CGI.unescape_html Nokogiri::HTML(open(url)).at("div.definition").text.gsub(/\s+/, ' ') rescue nil
    end

    def execute(m, word)
      unless check_ifban(m.user)
        m.reply(lookup(word) || "No results found", true)
      end
    end
  end
end