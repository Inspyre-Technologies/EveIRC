require 'cinch'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class WordGame
      include Cinch::Plugin

      set :plugin_name, 'wordgame'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      You can use the bot to play a word guessing game!
      Usage:
      * !word start: Starts the game in the channel in which this command is invoked.
      * !guess <word>: Take a guess at the secret word. The bot will tell you whether or not your guess comes before or after the secret word (alphabetically)
      * !word quit: Ends the game and reveals the secret word.
      USAGE

      def initialize(*)
        super
        @dict = Dictionary.from_file "/home/user/Eve-Bot/lib/plugins/config/words.txt"
      end

      match(/word start/i, method: :start)
      def start(m)
        return if check_ignore(m.user)
        m.reply "Starting a new word game"
        @word = Word.new @dict.random_word
      end

      match(/word quit/i, method: :peek)
      def peek(m)
        return if check_ignore(m.user)
        if @word
          m.reply "You quitter! Alright, the word was: #{@word.word}. Ending the game now!"
          @word = nil
          return
        end
      else
        m.reply "You can't quit a game that isn't in session!"
      end

      match(/guess (\S+)/i, method: :guess)
      def guess(m, guessed_word)
        return if check_ignore(m.user)
        if @word
          if @dict.word_valid? guessed_word
            if @word == guessed_word
              m.reply "#{m.user}: congratulations, that's the word! You win!"
              @word = nil
            else
              m.reply "My word comes #{@word.before_or_after?(guessed_word)} #{guessed_word}."
            end
          else
            m.reply "#{m.user}: sorry, #{guessed_word} isn't a word. At least, as far as I know"
          end
        else
          m.reply "You haven't started a game yet. Use `!word start` to do that."
        end
      end

      class Dictionary
        def initialize(words)
          @words = words
        end

        def self.from_file(filename)
          words = []
          File.foreach(filename) do |word|
            if word[0] == word[0].downcase && !word.include?("'")
              words << word.strip
            end
          end
          self.new(words)
        end

        def initialize(words)
          @words = words
        end

        def random_word
          @words.sample
        end

        def word_valid?(word)
          @words.include? word
        end
      end

      class Word < Struct.new(:word)
        def before_or_after?(other_word)
          word < other_word ? "before" : "after"
        end

        def ==(other_word)
          word == other_word
        end
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
