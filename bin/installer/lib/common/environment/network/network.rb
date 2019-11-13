class Setup
  module Helpers
    module Environment

      # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
      # @since 1.0
      #
      # A library of functions for the application to do_check for
      # network connection and DNS functionality.
      module Network
        require 'timeout'
        require_relative 'errors'

        @dns = 'google.com'
        @ip  = '8.8.8.8'

        # Performs a two-level do_check on the machine's network connectivity
        # checking first if it can ping google.com and then if that fails
        # checking to see if it can ping 8.8.8.8 therefore establishing if
        # failure of the first ping is due to DNS failure alone and not a
        # broader connection/hardware issue
        def self.check
          unless ping('dns')
            puts "Unable to ping #{@dns}"
            raise NetworkError unless ping('ip')

            raise DNSError
          end
          puts 'Ping of google.com was successful'
        end

        # Main work-horse for (see Network#do_check)
        def self.ping(type)

          @targ = case type

                  when 'dns'
                    @dns
                  when 'ip'
                    @ip
                  else
                    raise InternalApplicationError
                  end
          Timeout.timeout(5) {

            system "ping -c 1 #{@targ}"

          }

        end

      end
    end
  end
end