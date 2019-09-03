RSpec.describe "`eve_installer wizard` command", type: :cli do
  it "executes `eve_installer help wizard` command successfully" do
    output          = `eve_installer help wizard`
    expected_output = <<-OUT
Usage:
  eve_installer wizard

Options:
  -h, [--help], [--no-help]  # Display usage information

Starts the EveIRC install wizard to install the bot for you.
    OUT
    
    expect(output).to eq(expected_output)
  end
end
