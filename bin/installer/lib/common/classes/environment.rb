module EveIRCInstaller

  class Environment
    require_relative '../environment/network/network'
    require_relative '../environment/network/errors'
    attr_reader :elevated, :ruby

    @ruby = {
      version: 'print "ruby #{ RUBY_VERSION }p#{ RUBY_PATCHLEVEL }"'
    }

    def initialize
      @elevated = elevated?
    end

    # @return Boolean true we're elevated | false we're not
    def elevated?
      case Process.uid
      when 0
        true
      else
        false
      end

    end

  end

end
