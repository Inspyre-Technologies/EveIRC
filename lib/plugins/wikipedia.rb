require 'cinch'
require 'cinch/toolbox'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Wikipedia
      include Cinch::Plugin

      match /wiki (.*)/i
      match /wikipedia (.*)/i

      def initialize(*args)
        super
        @max_length = config[:max_length] || 300
      end

      def execute(m, term)
        return if check_ignore(m.user)
        m.reply get_def(term)
      end

      private

      def get_def(term)
        # URI Encode
        term = URI.escape(term, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        url = "http://en.wikipedia.org/w/index.php?search=#{term}"

        cats = Cinch::Toolbox.get_html_element(url, '#mw-normal-catlinks')
        if cats && cats.include?('Disambiguation')
          wiki_text = "'#{term} is too vague and lead to a disambiguation page."
        else
          # Grab the text
          wiki_text = Cinch::Toolbox.get_html_element(url, '#mw-content-text p')

          # Check for search errors
          return not_found(wiki_text, url) if wiki_text.nil? || wiki_text.include?('Help:Searching')
        end

        # Truncate text and url if they are too long
        text = Cinch::Toolbox.truncate(wiki_text, @max_length)
        url = Cinch::Toolbox.shorten(url)

        return Format(:green, "%s ∴ #{text} [#{url}]" % [Format(:bold, "Wikipedia")] )
      end

      def not_found(wiki_text, url)
        msg = "I couldn't find anything for that search"
        if alt_term_text = Cinch::Toolbox.get_html_element(url, '.searchdidyoumean')
          alt_term = alt_term_text[/\ADid you mean: (\w+)\z/, 1]
          msg << ", did you mean '#{alt_term}'?"
        else
          msg << ", sorry!"
        end
        return msg
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
