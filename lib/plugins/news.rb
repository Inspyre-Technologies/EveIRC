# @author Richard Banks <namaste@rawrnet.net>

# Feel free to join us in #Lobby on irc://rawr.sinsira.net where you can test this gem and get help!

require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'cgi'
require 'cinch/toolbox'
require_relative "helpers/category_helper.rb"
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class News
      include Cinch::Plugin

      set :plugin_name, 'news'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      This plugin is a comprehensive news aggregator and contacts several sources for articles.
      Enable/Disable Usage:
      * !n-categories: This command returns all the categories that you can choose from in a PM.
      * !n-subcategories <category ID>: This command returns all the subcategories of the specified category and their useable ID.
      * !news: This command retrieves the top three articles from the Top Stories subcategory of the Top News category.
      * !news <category ID>: This command retrieves the top three articles from the specified category.
      * !news <category ID> <subcategory ID>: This command retrieves the top three articles from the specified subcategory of the specified category.
      * !s-category <category id> <query>: This command searches the specified category for your query.
      USAGE

      match /n-categories/i, method: :list_categories

      match /n-subcategories (.+)/i, method: :list_subs

      match /news$/i, method: :top_news

      match /news (.+)$/i, method: :c_topnews

      match /news (.+?) (.+)/i, method: :sc_topnews

      match /s-category (.+?) (.+)/i, method: :search_category

      match /s-subcategory (.+?) (.+?) (.+)/i, method: :search_subcategory

      def list_categories(m)
        return if check_ignore(m.user)
        cat_list = categories
        ca_list = cat_list.join(", ")
        m.user.notice "#{ca_list}"
      end

      def list_subs(m, c_id)
        return if check_ignore(m.user)
        sc_list = sub_categories(c_id)
        s_list = sc_list.join(", ")
        m.user.notice "#{s_list}"
      end


      def search_category(m, id, terms)
        return if check_ignore(m.user)
        terms.gsub! /\s/, '+'
        search_list = execute_c_search(id, terms)
        search_list[0..2].each{|i| m.reply i}
      rescue OpenURI::HTTPError
        m.reply "Error: #{$!}"
      end

      def search_subcategory(m, id, sc_id, terms)
        return if check_ignore(m.user)
        terms.gsub! /\s/, '+'
        sc_search_list = execute_sc_search(id, sc_id, terms)
        sc_search_list[0..2].each{|i| m.reply i}
      rescue OpenURI::HTTPError
        m.reply "Error #{$!}"
      end

      def top_news(m)
        return if check_ignore(m.user)
        news = fetch_news
        news[0..2].each{|i| m.reply i}
      rescue OpenURI::HTTPError
        m.reply "Error #{$!}"
      end

      def c_topnews(m, id)
        return if check_ignore(m.user)
        c_news = c_top_news(id)
        c_news[0..2].each{|i| m.reply i}
      rescue OpenURI::HTTPError
        m.reply "Error #{$!}"
      end

      def sc_topnews(m, id, sc_id)
        return if check_ignore(m.user)
        sc_news = sc_top_news(id, sc_id)
        sc_news[0..2].each{|i| m.reply i}
      rescue OpenURI::HTTPError
        m.reply "Error #{$!}"
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
