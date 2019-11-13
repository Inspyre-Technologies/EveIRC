module EveIRCInstaller
  class Setup
    require_relative '../common/errors/error'
    require 'optparse'
    require 'bundler/inline'
    VERSION = File.open('somefile.txt', &:readline)

    require_relative '../bundle_man'

  end
end