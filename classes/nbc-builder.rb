require_relative ('./news-service')
require_relative ('./menu')

class NBC
  attr_accessor :nbc, :menu

	def initialize
		#make_archive
		@nbc = News_Service.new
		feed_rss(@nbc)
		@binder = {
			name: "News by Date",
      stories: []
    }
		create_binder(@nbc, @binder)
		#write_to_files(@nbc)
		#write_binder(@binder)
		options = [
			"\n\t1.- Digg (press 1)".colorize(:light_yellow),
			"\n\t2.- Reddit (press 2)".colorize(:light_yellow),
			"\n\t3.- Mashable (press 3)".colorize(:light_yellow),
			"\n\t4.- News by Date (press 4)".colorize(:light_yellow),
#			"\n\t5.- NBC in Lynx (press 5)".colorize(:light_yellow),
			"\n\t5.- Exit (press 5)".colorize(:light_red)
		]
		description = "An RSS interface for DIGG, REDDIT & MASHABLE"
		app_name = "nbc news".upcase.colorize(:green)
		@menu = Menu.new(
			options: options, 
			actions: method(:actions).to_proc, 
			app_name: app_name,
			description: description
			)
	end

	def actions(choice)
		case choice
			when 1
				@nbc.read_news(@nbc.stories.digg)
			when 2
				@nbc.read_news(@nbc.stories.reddit)
			when 3
				@nbc.read_news(@nbc.stories.mashable)
			when 4
				@nbc.read_news(@binder)
			#when 5
				#system("lynx ./services/index.html")		
			when 5
				abort("\n\tThank you for stopping by\n\n")
		end 
	end

	private
	def make_archive
		dp "Creating services folder => "
		system("mkdir services")
		dp "Creating HTML files..."
		File.new("./services/digg-news.html", "w+")
		File.new("./services/reddit-news.html", "w+")
		File.new("./services/mashable-news.html", "w+")
		File.new("./services/index.html", "w+")
	end
	def feed_rss(news_service)
		dp "feeding from digg"
		@nbc.get_digg(@nbc.stories.digg)
		dp "feeding from reddit"
		@nbc.get_reddit(@nbc.stories.reddit)
		dp "feeding from mashable"
		@nbc.get_mashable(@nbc.stories.mashable)
	end
	def create_binder(news_service,binder)
		dp "Creating binder..."
		n_stories = 0
		dp "filing digg in binder"
		digg_stories = @nbc.stories.digg[:stories]
		digg_stories.each do |news| 
			n_stories += 1
			binder[:stories] << news
		end
		dp "filing reddit in binder"
		reddit_stories =@nbc.stories.reddit[:stories]
		reddit_stories.each do |news| 
			n_stories += 1
			binder[:stories] << news
		end
		dp "filing mashable in binder"
		mashable_stories = @nbc.stories.mashable[:stories]
		mashable_stories.each do |news|
			n_stories += 1
			binder[:stories] << news
		end			
		binder[:stories].sort! do |prev,nxt| 
			prev[:datetime] <=> nxt[:datetime]
		end
		dp "#{n_stories} stories added to binder"
	end
	def write_to_files(news_service)
		digg = @nbc.stories.digg
		reddit = @nbc.stories.reddit
		mashable = @nbc.stories.mashable
		files = [
			"./services/digg-news.html", 
			"./services/reddit-news.html", 
			"./services/mashable-news.html"
		]
		dp "Writing to files"
		@nbc.write_news(files, digg, reddit, mashable)
	end	
	def write_binder(binder)
		dp "Writing files to binder..."
    File.open("./services/index.html", 'w') do |file|
    	file.puts "<!DOCTYPE html>"
      file.puts "<html>"
      file.puts "<head>"
      file.puts "	<title>NBC NEWS</title>"
      file.puts '<meta charset="utf-8">'
      file.puts '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
      file.puts '<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">'
			file.puts '<link rel="stylesheet" href="https://code.getmdl.io/1.2.0/material.indigo-pink.min.css">'
			file.puts '<script defer src="https://code.getmdl.io/1.2.0/material.min.js"></script>'
      file.puts "	<body>"
      file.puts '		<div id="container">'
      file.puts '		<a href="./digg-news.html">DIGG NEWS</a> - <a href=."/reddit-news.html">REDDIT NEWS</a> - <a href="./mashable-news.html">MASHABLE NEWS</a>'
      binder[:stories].each do |story|
        file.puts "		<p><b>Title:</b> #{story[:title]}<br>"
        file.puts "		<b>Author:</b> #{story[:author]}<br>"
        file.puts "		<b>Date:</b> #{(story[:datetime]).strftime("%d/%m/%Y at %T")}<br>"
        file.puts "		<b>Website:</b> <a href=#{story[:url]}>link</a><br>"
        file.puts "		<hr>"  
      end
      file.puts "		</div>"
      file.puts "	</body>"
      file.puts "	</head>"
      file.puts "</html>"
    end
  end
end		