module EveIRCInstaller
  # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
  # @since 1.0
  #
  # Class for creat ing/managing buffers for the EveIRCInstaller
  class BuffMan
    require 'fileutils'

    attr_accessor :buffer, :flush_count, :logfile

    @logfile = $logfile

    def initialize(opts = {})
      p Dir.pwd
      $logfile = create_file

      @buffer = {}
      $buffer = @buffer

      @flush_count = 1 unless @flush_count.is_a? Integer

    end

    def create_file
      filename = Time.now.to_f
      filename = filename.to_s.gsub!('.', '-')
      filename += '.txt'
      File.new '../../../' + filename, 'w'
    end

    # @param time [Time] The time EveIRCInstaller#create_file was first called, acts
    #   (for now) as a synonymn
    # @param
    def add_entry(time, lvl, message)
      time = time.to_f
      entry = {
        lvl: lvl,
        message: message
      }

      $buffer[time.to_s] = entry
      if $buffer.count >= $flush_cap
        flush
      end
    end

    def flush
      write_current
      $buffer = {}
      $flush_count = $flush_count + 1
    end

    def write_current
      $logfile << $buffer
    end

  end
end