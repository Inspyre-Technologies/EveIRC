module EveIRCInstaller
  class Log
    attr_reader :logger

    class InvalidArgumentError < StandardError; end

    class NoMessageError < Log::InvalidArgumentError

    end

    def initialize
      require 'tty-logger'
      @prompt = TTY::Prompt.new
    rescue LoadError
      $logger_fallback = true
    end

    def entry(params = {})
      message   = params[:message] | InvalidArgumentError::NoMessageError.new('No message included in request to log message')
      level     = params[:level] | 'info'
      timestamp = params[:time]
      if $logger_fallback && unless $logger_fallback.nil?
        put_default
      end
    end

  end
end