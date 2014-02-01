require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

# This plugin searches Urban Dictionary and prints the result to the IRC
# channel. 

module Cinch::Plugins
  class UrbanDictionary
    include Cinch::Plugin
    
    set :plugin_name, 'urban'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      This plugin searches Urban Dictionary and prints the result to the IRC channel that the command is called in.
      Usage:
      - !urban <query>: Has the bot look up the query/word and return to the channel with the result (if any)
    USAGE

    match /urban (.+)/
    
    def lookup(word)
      url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(word)}"
      CGI.unescape_html Nokogiri::HTML(open(url)).at("div.meaning").text.gsub(/\s+/, ' ') rescue nil
    end

    def execute(m, word)
        m.reply(lookup(word) || "No results found", true)
      end
    end
  end

# EVE is a project for a Top-Tier IRC bot, and the project could always use more help.
# Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at rawr.coreirc.org