require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

# This module is for searching with Google and printing the first result
# to the IRC channel that the function is called in.

module Cinch::Plugins
  class Google
    include Cinch::Plugin
	
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
