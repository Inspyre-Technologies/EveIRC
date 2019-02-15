require 'yaml'
# The script is for easy install of the gems Eve requires

# Below we are going to initialize this install script


def initialize(*args)
super
  puts "Checking if default config files exist..."
  begin
    if File.exist?('docs/userinfo.yaml')
      @storage = YAML.load_file('docs/userinfo.yaml')
    else
      @storage = {}
      puts "Creating user config file..."
      system("touch docs/userinfo.yaml")
      puts "User config file created! (userinfo.yaml)"
    end
    if File.exist?('docs/seen.yaml')
      puts "No need to write seen.yaml, already exists!"
    else
      puts "Seen.yaml not found, creating file..."
      system("touch docs/seen.yaml")
      puts "Seen.yaml created!"
    if File.exist?('docs/memos.yaml')
      puts "No need to write memos.yaml, already exists!"
    else
      puts "Memoes.yaml not found, creating file..."
      system("touch docs/memos.yaml")
      puts "Memoes.yaml created!"
    rescue => e
      puts "There seems to have been an issue! Please restart this script or file an issue!"
      puts "Exception Class: #{ e.class.name }"
      puts "Exception Message: #{ e.message }"
      puts "Exception Backtrace: #{ e.backtrace }"
    end
    puts"Finished checking for default config files."
  end
end

def update_store
  say "Updating storage with master information..."
  File.open('docs/userinfo.yaml', 'w') do |fh|
    YAML.dump(@storage, fh)
  end
end

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

def create_userfile
  puts "What is your IRC nickname? "
  answer = gets.chomp
  puts "Thank you, #{answer}"
  @storage = {}
  @storage[answer] ||= {}
  @storage[answer]['adminLevel'] = 0
  puts "Writing to config file..."
end

create_userfile

install_highline

require 'highline/import'
cli = HighLine.new
update_store
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

install_check("bundle")

say "Using Bundler to install needed gems..."
system *%W[bundle]

say "Required dependencies for eve6 now installed."
say "Once you've configured Eve you can start it using: ruby Eve.rb"

system("kill #{Process.pid}") # End program

