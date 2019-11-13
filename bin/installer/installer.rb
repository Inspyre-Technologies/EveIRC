
module EveIRCInstaller
  require_relative 'lib/common/modules/eve_irc_installer'
  class MainApplication


    def initialize

      Log.new
      p $buffer
      p $logfile

      $logger.entry(params={timestamp: Time.now,
                            message: 'This is a test of the logging system',
                            level: 'warn'
      })

      net_status = Environment::Network.check

      Setup.new
    rescue Environment::Network::ConnError => e

    end

  MainApplication.new

  end




end