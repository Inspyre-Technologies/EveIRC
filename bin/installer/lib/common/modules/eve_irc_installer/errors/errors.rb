module EveIRCInstaller
  class NetworkError < EveIRCInstaller::Environment::Network::ConnError; end

  class SetupApplicationError < EveIRCInstaller::Setup::InternalApplicationError; end

end