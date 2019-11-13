module EveIRCInstaller
  # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
  # @since 1.0
  #
  # Class for creat ing/managing buffers for the EveIRCInstaller
  class BuffMan

    attr_accessor :buffer, :flush_count, :file

    @upgrade = true

    def initialize(opts = {})
      @file        = opts[:file]
      @buffer      = {}
      @flush_count = 0 unless @flush_count.is_a? Integer
    end

    def add_entry(time, lvl, message)
      entry = { "#{time.to_f}": {
        lvl: lvl,
        message: message
      }
      }



    end


    def compose_entry(time, lvl, message)
      entry = { "#{time.to_f}": {
        lvl: lvl
                message:        message
      }
      }


    end

  end
end
end