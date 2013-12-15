require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

# This module is for searching with Google and printing the first result
# to the IRC channel that the function is called in.

module Cinch::Plugins
  class Google
    include Cinch::Plugin
    
    set :plugin_name, 'google'
    set :help, <<-USAGE.gsub(/^ {6}/, '')
      This plugin allows you to search Google!
      Usage:
      !google <query>: The bot will search Google for the top result and return to the channel with it!
    USAGE
    
    match /google (.+)/

  def search(query)
    url = "http://www.google.com/search?q=#{CGI.escape(query)}"
    res = Nokogiri::HTML(open(url)).at("h3.r")

    title = res.text
    link = res.at('a')[:href]
    desc = res.at("./following::div").children.first.text
    CGI.unescape_html "#{title} - #{desc} (#{link})"
  rescue
    "No results found"
  end

  def execute(m, query)
    m.reply(search(query))
  end
 end
end

# EVE is a project for a Top-Tier IRC bot, and the project could always use more help.
# Feel free to contribute at the github:  https://github.com/Namasteh/Eve-Bot
# For help with the Cinch framework you can always visit #Cinch at irc.freenode.net
# For help with EVE you can always visit #Eve at irc.catiechat.net