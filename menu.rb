=begin
Author: Daniel Castrillo
Project: NBC
Description: A menu builder class for all sorts of interfaces

{hack}
=end

require_relative './printers'

class Menu
  def initialize(attr={})
    dp "Building menu"
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
      puts "Welcome to #{@app_name}"
      puts "#{@description}\n".italic
      puts "MENU:".colorize(:light_blue).italic
      @options.each{|option| puts option}       
      puts ">> ".colorize(:light_blue).italic
      answer = input.to_i
      puts "#{answer}"
      break if answer > 0 && answer < top_range
      ep "That's not an option in the MENU, please chose again.\n\t(press enter)"
      gets
    end
    system ("clear")
    @actions.call(answer)
  end
end