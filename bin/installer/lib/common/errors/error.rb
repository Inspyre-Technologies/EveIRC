module EveIRCInstaller

  class BundlerError < StandardError

    class InstallError < BundlerError
      attr_reader :wiki

      def initialize(params = {})
        @wiki = params[:wiki] || 'There was an issue with your install'
        @msg = message

      end



    end

  end

end