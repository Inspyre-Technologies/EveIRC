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
        url1a:        results[0].css("id").inner_text(),
        
        title2:      results[1].css("title").inner_text(),
        content2:    results[1].css("content").inner_text(),
        author2:     results[1].css("author").css("name").inner_text(),
        url2a:        results[1].css("id").inner_text(),
        
        title3:      results[2].css("title").inner_text(),
        content3:    results[2].css("content").inner_text(),
        author3:     results[2].css("author").css("name").inner_text(),
        url3a:        results[2].css("id").inner_text()
      )
      end
      
    def result(m, data)
      url1 = data.url1a.split("http://gdata.youtube.com/feeds/api/videos/")[1]
      url2 = data.url2a.split("http://gdata.youtube.com/feeds/api/videos/")[1]
      url3 = data.url3a.split("http://gdata.youtube.com/feeds/api/videos/")[1]
      m.reply Format("%s 3Title: #{data.title1} | #{data.content1} | By: #{data.author1} | http://youtu.be/#{url1}" % "0,4You1,0Tube")
      m.reply Format("%s 3Title: #{data.title2} | #{data.content2} | By: #{data.author2} | http://youtu.be/#{url2}" % "0,4You1,0Tube")
      m.reply Format("%s 3Title: #{data.title3} | #{data.content3} | By: #{data.author3} | http://youtu.be/#{url3}" % "0,4You1,0Tube")
    end  
  end
end
end
