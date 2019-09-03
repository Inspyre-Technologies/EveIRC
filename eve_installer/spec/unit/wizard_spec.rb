require 'eve_installer/commands/wizard'

RSpec.describe EveInstaller::Commands::Wizard do
  it "executes `wizard` command successfully" do
    output  = StringIO.new
    options = {}
    command = EveInstaller::Commands::Wizard.new(options)
    
    command.execute(output: output)
    
    expect(output.string).to eq("OK\n")
  end
end
