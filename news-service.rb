=begin
Author: Daniel Castrillo
Project: NBC
Description: Experimenting database of resources

{hack}
=end

require 'net/http'
require 'json'
require 'date'
require 'time'
require_relative './stories'
require_relative './printers'

class News_Service
  attr_accessor :stories

  def initialize
    dp "Creating News Service"
    @stories = Stories.new
    @art_index = 0
  end

  def get_digg(binder) # 10 news by day
    digguri = URI("http://digg.com/api/news/popular.json")
    digg = JSON.parse(Net::HTTP.get(digguri))
    count = 0
    digg["data"]["feed"].each do |feeds|
      binder[:stories][count] = {}
      binder[:stories][count][:title] = feeds["content"]["title_alt"]
      binder[:stories][count][:author] = feeds["content"]["author"]
      binder[:stories][count][:datetime] = (Time.at(feeds["date"])).to_datetime
      binder[:stories][count][:url] = feeds["content"]["original_url"]
      binder[:stories][count][:content] = feeds["content"]["description"]
      binder[:stories][count][:art_num] = @art_index +1
      @art_index += 1
      count += 1
    end
    dp "Digg news saved to service"
  end

  def get_reddit(binder) # 25 news randomly refreshed
    endpoint = 'www.reddit.com'
    resource = "/.json"
    uri = URI("https://#{endpoint}#{resource}")
    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = "vand\'s NBC news service"
    response =  Net::HTTP.start(uri.hostname){|http| http.request(request)}
    reddit = JSON.parse(response.body)
    count = 0
    reddit["data"]["children"].each do |children|
      binder[:stories][count] = {}
      binder[:stories][count][:title] = children["data"]["title"]
      binder[:stories][count][:author] = children["data"]["author"]
      binder[:stories][count][:datetime] = (Time.at(children["data"]["created"])).to_datetime
      binder[:stories][count][:url] = children["data"]["url"]
      binder[:stories][count][:content] = "subreddit - /#{children["data"]["subreddit"]}"
      binder[:stories][count][:art_num] = @art_index + 1
      @art_index += 1
      count += 1
    end
    dp "Reddit news saved to service"
  end

  def get_mashable(binder) # Huge amount of news
    options = ["new","rising","hot"]
    choice = options[rand(3)]
    mashableuri = URI("http://mashable.com/stories.json")
    mashable = JSON.parse(Net::HTTP.get(mashableuri))
    count = 0
    mashable[choice].each do |stories|
      binder[:stories][count] = {}
      binder[:stories][count][:title] = stories["title"]
      binder[:stories][count][:author] = stories["author"]
      binder[:stories][count][:datetime] = (Time.parse(stories["post_date_rfc"])).to_datetime
      binder[:stories][count][:url] = stories["link"]
      binder[:stories][count][:content] = stories["content"]["plain"]
      binder[:stories][count][:art_num] = @art_index + 1
      @art_index += 1
      count += 1
    end 
    dp "Mashable news saved to service"
  end

  def write_news(files, digg, reddit, mashable)
    services = [digg, reddit, mashable]
    3.times do |x|
      dp "Writing to #{services[x][:name]} file..."
      File.open(files[x], 'w') do |file|
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
        file.puts "   <h1>#{services[x][:name]} news services</h1>\n"
        services[x][:stories].each do |story|        
          file.puts "   <p><b>Title:</b> #{story[:title]}<br>"
          file.puts "   <b>Author:</b> #{story[:author]}<br>"
          file.puts "   <b>Date:</b> #{(story[:datetime]).strftime("%d/%m/%Y at %H")}<br>"
          file.puts "   <b>Website:</b> <a href=#{story[:url]}>link</a><br>"
          file.puts "   <b>Article #{story[:art_num]}</b></p>\n\n<br>"
          file.puts "   <hr>"    
        end
        file.puts " </body>"
        file.puts " </head>"
        file.puts "</html>"
      end
    end
  end

  def read_news(service)
    system("clear")
    count = 1
    paginator = 0
    dp "#{service[:name]} news services\n".colorize(:light_blue)
    service[:stories].each do |story|  
      puts "Title: ".colorize(:yellow) + " #{story[:title]}".bold
      puts "Author: ".colorize(:red) + " #{story[:author]}"
      puts "Date: ".colorize(:green) + "#{(story[:datetime]).strftime("%d/%m/%Y at %T")}"
      puts "Website:".colorize(:blue) + " #{story[:url]}"
      puts "Article #{story[:art_num]}".colorize(:cyan)
      puts "-"*120    
      if count % 5 == 0
        paginator += 1
        puts "(page #{paginator})\n"
        puts "press q to go back to menu".colorize(:light_red).italic
        puts "press s to visit a link".colorize(:light_yellow).italic
        puts "press anything else to see next 5 news".colorize(:light_blue).italic
        puts ">>".colorize(:light_blue).italic
        answer = input.downcase
        break if answer == "q"
        if answer == "s"
          puts "enter article number: ".colorize(:light_blue).italic
          art_num = gets.chomp.to_i 
          unless art_num.is_a? Integer
            puts "That not a number"
            art_num = gets.chomp.to_i      
          end
          browse_link(service, art_num)
        end
        system("clear")
      end
      count += 1            
    end    
  end

  def browse_link(service, art_num)
    link = ((service[:stories].select {|article| art_num == article[:art_num]}).first)[:url]
    if link
      puts "Opening a link to #{link}..."
      system("xdg-open 2> /dev/null #{link}")
    else
      ep "Thats not a available article number"
    end
  end
end





