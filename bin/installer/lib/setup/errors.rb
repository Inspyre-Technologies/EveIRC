class Setup

  class InternalApplicationError < StandardError
    attr_reader :msg, :hint

    def initialize
      @msg  = 'There has been an unknown error'
      @hint = 'This is most likely a programming error'\
              ', therefore you should probably file an'\
              'issue.'
    end

  end
end