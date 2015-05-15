def install_check(gem)
  puts "Checking if '#{gem}' is installed."
  if system("gem list -i #{gem}")
    puts "Found '#{gem}'."
  else
    puts "Gem '#{gem}' is not installed, installing..."
    system("gem install #{gem}")
    puts "Installation of '#{gem}' successful!"
  end
end

puts "Welcome to eve7."
puts "Would you like to run an update on your Ruby Gems? [y/n]"
answer = gets.downcase
if answer == "y"
  system("gem update")
else
  puts "Continuing without updating..."
end
puts "Checking basic dependencies..."
puts "Checking if 'cinch' is installed..."
install_check("cinch")
puts "Checking if 'highline' is installed..."
install_check("highline")
puts "Checking if 'activesupport' is installed..."
install_check("activesupport")
puts "Required dependencies for eve7 now installed."
puts "Opening install script..."
system("kill #{Process.pid} && ruby install.rb")

