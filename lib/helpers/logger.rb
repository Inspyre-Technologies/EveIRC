require 'highline'
require_relative 'timestamp'

module Cinch
  module Helpers
    
    def log_message(level, message, plugin_name="Core", timer="no")
      time = timestamp
      name = "| <%= color('#{plugin_name}', BOLD, UNDERLINE, GREEN) %> |"
      indicator = "<%= color('--', BOLD, GREEN) %>" if level == "message"
      indicator = "<%= color('**', BOLD, YELLOW) %>" if level == "warn"
      indicator = "<%= color('!!', BOLD, RED) %>" if level == "error"
      @logMessage = "#{time} #{name} #{indicator} #{message}"
      say("#{@logMessage}")
      sleep(2) if timer == "yes"
    end
  end
end
