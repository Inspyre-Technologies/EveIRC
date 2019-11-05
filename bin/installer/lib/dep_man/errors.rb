class EveInstaller
  class DepMan

    # @since 5.09
    #
    # Error class that acts as a namespace for it's children as
    # well as serving to denote a general problem with installing
    # missing dependencies
    class MissingDependenciesError < StandardError

      # @since 5.09
      #
      # Error class raised when dependencies are not present and
      # user declined allowing the program to install them

      class UserDeclineError < MissingDependenciesError

        # The message that will be returned about this error
        def msg
          'I have found gems that need to be installed in order to run '\
          'self-install. However, user declined install.'
        end

        # More information that might be useful for debugging or
        # pointing the end-user in the right direction for
        # documentation
        def hint
          'Check $PROG_ROOT/lib/dep_man/missing.deps and install the '\
          'missing gems or run the install script again and accept '\
          'the auto-install when asked.'
        end
      end

    end

    # @since 5.09
    #
    # Error class that is raised when the program detects
    # that it's running without sudo access or root privileges
    # in an environment where said access is need in order to
    # install the ruby gems required for the eveIRC installer
    class PermissionsError < StandardError

      # The message that will be returned about this error
      def msg
        'I have detected that super-user access is '\
               'needed to install required gems due to where '\
               'your Ruby install is located. However, I was '\
               'unable to attain super-user.'
      end

      # More information that might be useful for debugging or
      # pointing the end-user in the right direction for
      # documentation
      def hint
        @hint = "Try to install again using 'sudo eve_install'"
      end
    end

  end
end
