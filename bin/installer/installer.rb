
module EveIRCInstaller
  class MainApplication
    require_relative 'lib/helpers/parser'
    Helpers::Parser.parse(ARGV)


    p 'The options are ' + $options.to_s

    require_relative 'lib/common/modules/eve_irc_installer'






    def initialize(*)
      p ARGV



      Log.new
      p $buffer
      p $logfile

      $logger.entry(params={timestamp: Time.now,
                            message: 'This is a test of the logging system',
                            level: 'warn'
      })

      net = Environment::Network

      Setup.new
    rescue Environment::Network::ConnError => e

    end

  MainApplication.new

  end




end