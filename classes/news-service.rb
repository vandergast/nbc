=begin
Author: Daniel Castrillo
Project: NBC
Description: Experimenting database of resources

{hack}
=end

require 'launchy'
require_relative './stories'
require_relative './digg'
require_relative './reddit'
require_relative './mashable'
require_relative '../core_exts/printers'

class News_Service
  attr_accessor :stories
  def initialize
    dp "Creating News Service"
    @stories = Stories.new
    @art_index = 0
  end

  def get_digg(binder) # 10 news by day
    digg = Digg.new
    @stories.digg[:stories] = digg.data
  end

  def get_reddit(binder) # 25 news randomly refreshed
    reddit = Reddit.new
    @stories.reddit[:stories] = reddit.data
  end

  def get_mashable(binder) # Huge amount of news
    mashable = Mashable.new
    @stories.mashable[:stories] = mashable.data
  end

  def write_news(files, digg, reddit, mashable)
    services = [digg, reddit, mashable]
    3.times do |x|
      dp "Writing to #{services[x][:name]} file..."
      File.open(files[x], 'w') do |file|
        file_headers(file)
        file.puts "   <h1>#{services[x][:name]} news services</h1>\n"
        services[x][:stories].each do |story|        
          file_body(file, story)
        end
        file_footers(file)
      end
    end
  end

  def read_news(service)
    system("clear")
    article_count = 1
    paginator = 0
    puts "#{service[:name]} news services\n".colorize(:light_blue)
    service[:stories].each do |story|  
      read_format(story)
      if article_count % 5 == 0
        paginator += 1
        answer = read_menu(paginator)
        break if answer == "q"
        if answer == "s"
          browse_link(service)
          gets
          break
        end
        system("clear")
        puts "#{service[:name]} news services\n".colorize(:light_blue)
      end
    article_count += 1          
    end    
  end

  def browse_link(service)
    puts "enter article number: ".colorize(:light_blue)
    art_num = gets.chomp.to_i 
    unless art_num.is_a? Integer
      puts "That not a number"
      art_num = gets.chomp.to_i      
    end
    link = ((service[:stories].select {|article| art_num == article[:art_num]}).first)[:url]
    if link
      system("clear")
      puts "Opening a link to" + " => ".colorize(:yellow) + "#{link}".colorize(:light_blue)
      puts "(press enter to go back to the menu)".colorize(:red)
      system("launchy 2> /dev/null #{link}")
    else
      ep "Thats not a available article number"
    end
  end

  private

  def read_format(story)
    puts "Title: ".colorize(:yellow) + " #{story[:title]}".bold
    puts "Author: ".colorize(:red) + " #{story[:author]}"
    puts "Date: ".colorize(:green) + "#{(story[:datetime]).strftime("%d/%m/%Y at %T")}"
    puts "Website:".colorize(:blue) + " #{story[:url]}"
    puts "Article #{story[:art_num]}".colorize(:cyan)
    puts "-"*120   
  end

  def read_menu(paginator)
    puts "(page #{paginator})\n"
    puts "press q to go back to menu".colorize(:light_red)
    puts "press s to visit a link".colorize(:light_yellow)
    puts "press anything else to see next 5 news".colorize(:light_blue)
    puts ">>".colorize(:light_blue)
    answer = input.downcase
  end

  def file_headers(file)
    file.puts "<!DOCTYPE html>"
    file.puts "<html>"
    file.puts " <head>"
    file.puts " <title>NBC NEWS</title>"
    file.puts ' <meta charset="utf-8">'
    file.puts ' <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    file.puts ' <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">'
    file.puts ' <link rel="stylesheet" href="https://code.getmdl.io/1.2.0/material.indigo-pink.min.css">'
    file.puts ' <script defer src="https://code.getmdl.io/1.2.0/material.min.js"></script>'
    file.puts " <body>"
    file.puts '   <div id="container">'
    file.puts '   <a href="./index.html">HOME</a>'
  end

  def file_body(file, story)
    file.puts "   <p><b>Title:</b> #{story[:title]}<br>"
    file.puts "   <b>Author:</b> #{story[:author]}<br>"
    file.puts "   <b>Date:</b> #{(story[:datetime]).strftime("%d/%m/%Y at %H")}<br>"
    file.puts "   <b>Website:</b> <a href=#{story[:url]}>link</a><br>"
    file.puts "   <b>Article #{story[:art_num]}</b></p>\n\n<br>"
    file.puts "   <hr>"        
  end

  def file_footers(file)
    file.puts " </body>"
    file.puts " </head>"
    file.puts "</html>"
  end
end




