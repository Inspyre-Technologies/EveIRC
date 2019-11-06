class EveInstaller
  class DepMan
    require_relative 'dep_man/dep_man'

    def start
      begin
        DepMan.new


      rescue DepMan::MissingDependenciesError::UserDeclineError => e
        puts e.msg
        puts e.hint unless @no_hint
        puts 'Exiting...'

      rescue DepMan::PermissionsError => e
        report_error(e, ['prog_error'])

      rescue DepMan::InfiniteInstallError => e
        report_error(e, %w(prog_error give_doc))

      end
    end

  end
end