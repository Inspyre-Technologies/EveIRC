module EveIRCInstaller
  class Log
    require_relative 'log/lib/buff_man'

    attr_reader :logger

    class InvalidArgumentError < StandardError
    end

    class NoMessageError < Log::InvalidArgumentError

    end

    def initialize
      require 'tty-logger'
      start
    rescue LoadError
      start(true)
    end

    def start(fallback = false)
      start_fallback if fallback
      deps = ['tty-prompt', 'tty-logger']
      begin
        DepMan::Gems.load
      rescue LoadError

      end


    end

    def start_fallback

      require 'logger'

    end

    def entry(params = {})
      time      = params[:timestamp]
      message   = params[:message]
      level     = params[:level]
      new_entry = {}
    end
  end
end
