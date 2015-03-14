# Author: Richard Banks
# E-Mail: namaste@rawrnet.net
# lib/helpers/greetings.rb: This helper will give 
# lines of text that the bot can use to greet users
# if they join a channel that it's in.

require_relative '../logger'
require_relative '../determine_name'

module Cinch
  module Helpers
    
    def greet_neutral(m)
      # This method is for greetings of people who
      # don't have a greeting set in Eve, or are not
      # 'friends' with the bot.
      [
        "Hi #{determine_name(m)}!",
        "Hello #{determine_name(m)}! Welcome to #{m.channel}!",
        "#{determine_name(m)}, how are ya?",
        "Oh hi there, #{determine_name(m)}.",
        "Welcome to #{m.channel}, #{determine_name(m)}.",
        "Hello, and welcome to #{m.channel}, #{determine_name(m)}. Cake, and grief counselling, will be available at the conclusion of your visit."
      ].sample
    end
  end
end