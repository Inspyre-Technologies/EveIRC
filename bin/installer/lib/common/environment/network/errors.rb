class Setup
  module Helpers
    module Environment
      module Network

        # Error class to be raised when the program has determined a lack
        # of internet connectivity. This error (when raised) would precede
        # the program exiting with a non-zero exit code ('error-ing out')
        class NetworkError < StandardError

          def msg
            'Eve Installer has detected network failure, unable to connect!'
          end

          def hint
            'Check to see if this machine is connected to the Internet'
          end

        end

        # Error class to be raised when the program has determined an error
        # in DNS connectivity. This error does not necessarily precede a
        # program exit. For example; if the program does not have to install
        # any dependencies whatsoever - this error will never cause a
        # non-zero program exit.
        class DNSError < NetworkError

          def msg
            'DNS Failure!'
          end

          def hint
            'Unable to find google.com, do_check your DNS settings.'
          end

        end

      end
    end
  end
end
