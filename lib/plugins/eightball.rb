require 'cinch'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Eightball
      include Cinch::Plugin
      include Cinch::Helpers

      set :plugin_name, 'eightball'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Time for some fun, and some fortune telling! Ask the magic eightball any yes or no question and it will give you an answer!
      Usage:
      - !8ball <question>: The eightball will give you an answer. Note: the question should be a yes or no question.
      USAGE

      @@eightball = [
        "It is certain",
        "It is decidedly so",
        "Without a doubt",
        "Yes - definitely",
        "You may rely on it",
        "As I see it, yes",
        "Most likely",
        "Outlook good",
        "Signs point to yes",
        "Yes",
        "Reply hazy, try again",
        "Ask again later",
        "Better not tell you now",
        "Cannot predict now",
        "Concentrate and ask again",
        "Don't count on it",
        "My reply is no",
        "My sources say no",
        "Outlook not so good",
        "Very doubtful"
      ]

      def shake!
        @@eightball.sample
      end


      match /8ball (.+)/i
      def execute(m, s)
        return if check_ignore(m.user)
        questions = s.split("? ")
        answers = [];
        questions.each {|question|
                        question[0] = question[0].upcase
                       answers << "\"#{question.delete("?")}?\" #{shake!}"
                       }
        output = answers.join(". ") + "."
        m.safe_reply output, true
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
