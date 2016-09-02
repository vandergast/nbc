=begin
Author: Daniel Castrillo
Project: NBC
Description: News By Continent Program

{hack}
=end

require_relative './nbc-builder'


def main
	app = NBC.new
	menu = app.menu
	puts "Everything ready to run (press any key to continue)"
	gets
	██╗  ██╗█████╗ ██╗     ██╗      ██████╗    ██╗    ██╗    ██████╗  ██████╗  ██╗        ██████╗ 
	██║  ██║██╔═══╝ ██║     ██║     ██╔═══██╗   ██║     ██║  ██╔═══ ██╗ ██╔══██╗  ██║        ██╔══██╗
	██████║█████╗ ██║     ██║     ██║   ██║    ██║ █╗ ██║  ██║    ██║ ██████╔╝ ██║         ██║  ██║
	██╔══██║██╔══╝  ██║     ██║     ██║   ██║    ██║███╗██║ ██║    ██║ ██╔══██╗  ██║         ██║  ██║
	██║  ██║█████╗ █████╗ █████╗╚█████╔╝    ╚███╔███╔╝  ╚██████╔╝ ██║  ██║  ███████╗ ██████╔╝
	 ╚═╝  ╚═╝╚══════╝ ╚══════╝ ╚══════╝ ╚═════╝        ╚══╝ ╚══╝     ╚═════╝    ╚═╝  ╚═╝     ╚══════╝    ╚═════╝ 
                                                                                        
	while true
		menu.call_menu()
	end
end

main


