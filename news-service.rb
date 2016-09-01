=begin
Author: Daniel Castrillo
Project: NBC
Description: Experimenting database of resources

{hack}
=end

require 'net/http'
require 'json'
require 'colorize'
require 'date'
require 'time'
require './stories'


class News_Service
  attr_accessor :stories

  def initialize
    puts "Creating News Service"
    @stories = Stories.new
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
      binder[:stories][count][:art_num] = count +1
      count += 1
    end
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
      binder[:stories][count][:art_num] = count + 1
      count += 1
    end
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
      binder[:stories][count][:art_num] = count + 1
      count += 1
    end 
  end

  def write_news(files, digg, reddit, mashable)
    services = [digg, reddit, mashable]
    3.times do |x|
      puts "Writing to #{services[x][:name]} file..."
      File.open(files[x], 'w') do |file|
        file.puts "<!DOCTYPE html>"
        file.puts "<html>"
        file.puts "<head>"
        file.puts "<title>NBC NEWS</title>"
        file.puts "<body>"
        file.puts "\n\t<h1>#{services[x][:name]} news services</h1>\n"
        services[x][:stories].each do |story|        
          file.puts "\n\t<p><b>Title:</b> #{story[:title]}<br>"
          file.puts "\n\t<b>Author:</b> #{story[:author]}<br>"
          file.puts "\n\t<b>Date:</b> #{(((Time.parse((story[:datetime]).to_s)).to_s).split(" "))[0]}<br>"
          file.puts "\n\t<b>Time:</b> #{(((Time.parse((story[:datetime]).to_s)).to_s).split(" "))[1]}<br>"
          file.puts "\n\t<b>Website:</b> <a href=#{story[:url]}>link</a><br>"
          file.puts "\n\t<b>Article #{story[:art_num]}</b></p>\n\n<br>"
          file.puts "<hr>"    
        end
        file.puts "</body>"
        file.puts "</head>"
        file.puts "</html>"
      end
    end
  end
=begin
  def browse_link
    print "\tChose a news service: "
    service = gets.chomp.upcase
    print "\n\tChoose an article # from #{service}: "
    art_num = gets.chomp.to_i
    cases = [@stories.digg,@stories.reddit,@stories.mashable]
    if service == "DIGG"
      link = ((cases[0][:stories].select {|article| art_num == article[:art_num]}).first)[:url]
      puts "\tOpening a #{service} link to #{link}..."
      system("xdg-open", link)
    elsif service == "REDDIT"
      link = ((cases[1][:stories].select {|article| art_num == article[:art_num]}).first)[:url]
      puts "\tOpening a #{service} link to #{link}..."
      system("xdg-open", link)
    elsif service == "MASHABLE"
      link = ((cases[2][:stories].select {|article| art_num == article[:art_num]}).first)[:url]
      puts "\tOpening a #{service} link to #{link}..."
      system("xdg-open", link)
    else
      puts "Thats not a service we provide"
    end
  end
=end
end





