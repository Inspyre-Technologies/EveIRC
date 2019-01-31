
# The script is for easy install of the gems Eve requires




# This function checks if a gem is installed and installs it if it isn't
def install_check(gem)
  say "Checking if '#{gem}' is installed."
  if system('gem list -i "^#{gem}$"') # This ensures we don't get a false positive
    say "Found '#{gem}'."
  else
    say "Gem '#{gem}' is not installed, installing..."
    system("gem install #{gem}")
    say "Installation of '#{gem}' successful!"
  end
end

# This function is for installing highline to make output pretty
def install_highline
  puts "In order to continue with automatic installation 'highline' is required!"
  puts "Should I install the 'highline' gem now? [y/n]:"
  answer = gets.chomp
  if answer.downcase != 'y'
    puts "Highline is needed to proceed! Exiting in 3 seconds..."
    puts "Please see documentation for manual install."
    sleep 3
    system("kill #{Process.pid}")
  else
    system("gem install highline")
  end
end

# Here we check to see if highline is installed
puts "Checking to see if 'highline' is installed..."
if system('gem list -i "^highline$"')
  puts "Looks like 'highline' is already installed, good!"
  sleep 2
else
  puts "Looks like 'highline' is NOT installed"
  install_highline # Install highline if it's not
end

# Prepare script to use highline
require 'highline/import'
cli = HighLine.new
system("clear")

# Start main script, ask if they wanna update their gems
say "Welcome to eve6!"
if agree("Would you like to run an update on your Ruby Gems? [y/n]: ", true)
  system("gem update")
  say("Your gems have been updated!")
else
  say("Ok! Continuing without updating...")
end

# Confirm that they want us installing gems
say "This script is for use if you plan on using a full-featured Eve."
say "We will install things to your system using gems."
if agree("Would you like to proceed? [y/n]: ", true)
  say "Alright! Proceeding with framework install!"
else
  say "Please see documentation to continue."
  system("kill #{Process.pid}")
end

# Start checking for bundler, and then install based on Gemfile
say "Checking basic dependencies..."

install_check("bundler")
say "Using Bundler to install needed gems..."
system *%W[bundle]

say "Required dependencies for eve6 now installed."
say "Once you've configured Eve you can start it using: ruby Eve.rb"

system("kill #{Process.pid}") # End program

