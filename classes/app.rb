=begin
Author: Daniel Castrillo
Project: NBC
Description: News By Continent Program

{hack}
=end

require_relative './nbc-builder'

class App
	def run
		app = NBC.new
		menu = app.menu
		puts "Everything ready to run (press any key to continue)".colorize(:light_blue)
		gets                                                                              
		while true
			menu.call_menu()
		end
	end
end



