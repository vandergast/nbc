=begin
Author: Daniel Castrillo
Description: A library of commonly used functions

{hack}
=end

require 'colorize'

def puts(string) # User Interface printer
	print "\n\t#{string}"
end 

def dp(string) # Debug printer
	print "\n	#{string}".colorize(:yellow)
end

def ep(string) # Error printer
	print "\n\t#{string}".colorize(:red)
	gets
end

def input
	begin
		state = `stty -g`
		`stty raw -echo -icanon isig`
		answer = STDIN.getc.chr
	ensure
  	`stty #{state}`
  end
  return answer
end