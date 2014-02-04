require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

module Cinch
  module Plugins
    class YouTube
      include Cinch::Plugin
      
      set :prefix, /^~/
      
      match /youtube (.+)/
      
    def execute(m, query)
      query.gsub! /\s/, '+'
      data = lookup(m, query)
      return m.reply "No results found for #{query}." if data.nil?
      result(m, data)
    end
      
    def lookup(m, terms)
      doc = Nokogiri::XML(open("https://gdata.youtube.com/feeds/api/videos?q=#{terms}"))
      results = doc.css("entry")
      results.each{|i| puts i.css("title").inner_text()}
      
      OpenStruct.new(
        title1:      results[0].css("title").inner_text(),
        content1:    results[0].css("content").inner_text(),
        author1:     results[0].css("author").css("name").inner_text(),
        url1a:        results[0].css("id").inner_text()
      )
      end
      
    def result(m, data)
      url1 = data.url1a.split("http://gdata.youtube.com/feeds/api/videos/")[1]
      m.reply Format("%s 3Title: #{data.title1} | #{data.content1} | By: #{data.author1} | http://youtu.be/#{url1}" % "0,4You1,0Tube")
    end  
  end
end
end
