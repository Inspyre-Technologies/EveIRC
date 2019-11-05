class EveInstaller

  class InternalApplicationError < StandardError
    attr_accessor :msg, :hint

    @msg = 'An error occurred in the programs logic, please file an issue!'

  end
end
