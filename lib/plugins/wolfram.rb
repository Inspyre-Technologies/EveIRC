require 'wolfram-alpha'

module Cinch
  module Plugins
    class Wolfram
      include Cinch::Plugin

      set :required_options, [:key]
      set :plugin_name, 'wolfram'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Query Wolfram|Alpha with questions or stats!
      Usage:
      !wa <query>: The bot will query Wolfram|Alpha and return with results (if there are any).
      USAGE

      match /wa (.+)/

      def execute(m, search)
        key = config[:key]

        options = { "format" => "plaintext" }

        client = WolframAlpha::Client.new "#{key}", options
        response = client.query "#{search}"

        input = response["Input"]
        result = response.find { |pod| pod.title == "Result" }

        return m.reply "Error: Result not found" if result.nil?

        m.reply "#{input.subpods[0].plaintext} = #{result.subpods[0].plaintext}"
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
