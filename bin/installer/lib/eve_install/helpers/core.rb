class EveInstaller
  require_relative 'core/errors.rb'
  module Core


    def self.lookup_code(query)
      code_table = {
        decline_install: 'User declined automatic install of rubygem dependencies.',
        decline_su: 'The program detected the need for elevated privileges '\
                            'in order to continue but failed to retain them.'
      }
      code_table = code_table.to_h
      query = query.to_sym
      if code_table.key?(query)
        puts code_table[query]
      else
        'Unknown error code. Maybe file an issue on github?'
      end
    end

    def self.user_exit(query)
      reason = lookup_code(query)
      puts reason
      exit

    end


  end
end