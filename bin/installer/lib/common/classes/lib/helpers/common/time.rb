module EveIRCInstaller

  module Helpers

    # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
    # @since 1.0
    #
    # A module containing functions for getting various
    # formats of the current system time.
    module Time
      attr_accessor :to_filename
      @time = Time.now

      @to_filename = format_secs_to_str

      def float_str_w_dec
        time = @time.to_f
        time.to_s
      end

      def format_secs_to_str
        time = @time.to_f
        time = time.to_s.gsub!'.', ' '
        return time
      end

    end

  end

end