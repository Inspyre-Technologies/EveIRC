module EveIRCInstaller
  module WebResources
    attr_reader :github, :wiki, :issues

    @github = 'https://github.com/Inspyre-Technologies/EveIRC'
    @wiki   = @github + '/wiki'
    @issues = @github + '/issues/new?assignees=doubledave%2C+tayjaybabee'\
                        '&labels=installer%2C+Investigating&template='\
                        'installer_issue.md&title=%5BINSTALLER%3A+Issue%5D'

  end
end