class EveInstaller
  module Helpers
    module Environment
      require_relative 'environment/network/network'

      def self.need_sudo?
        Gem.ruby.include?('/usr/bin/ruby') ? true : false
      end
    end

  end
end