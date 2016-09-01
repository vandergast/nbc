=begin
Author: Daniel Castrillo
Project: NBC
Description: A menu builder class for all sorts of interfaces

{hack}
=end

class Menu
  def initialize(attr={})
    puts "Building menu"
    @options = attr[:options] # The options available for the user
    @actions = attr[:actions] # A proc that executes the selected option
    @app_name = attr[:app_name] # The name of the app
    @description = attr[:description]
  end

  def call_menu
    top_range = @options.length + 1
    answer = 0
    loop do
      system ("clear")
      print "\n\tWelcome to #{@app_name} - #{@description}\n"
      print "\n\tMENU:".colorize(:light_blue)
      @options.each{|option| puts option}       
      print "\n\t>> ".colorize(:light_blue)
      system("stty raw -echo")
      answer = STDIN.getc.to_i
      system("stty -raw echo")
      puts "#{answer}"
      break if answer > 0 && answer < top_range
      print "\n\tThat's not an option in the MENU, please chose again.\n\t(press enter)".colorize(:red)
      gets
    end
    system ("clear")
    @actions.call(answer)
  end
end