require 'net/http'
require 'json'
require 'date'
require 'time'

class Digg
	attr_reader :data
	def initialize
		@data = self.get
	end
	def get
		uri = URI("http://digg.com/api/news/popular.json")
	  digg = JSON.parse(Net::HTTP.get(uri))
	  count = 0
	  binder = []
	  digg["data"]["feed"].each do |feeds|
	    binder[count] = {}
	    binder[count][:title] = feeds["content"]["title_alt"]
	    binder[count][:author] = feeds["content"]["author"]
	    binder[count][:datetime] = (Time.at(feeds["date"])).to_datetime
	    binder[count][:url] = feeds["content"]["original_url"]
	    binder[count][:content] = feeds["content"]["description"]
	    binder[count][:art_num] = count +1
	    count += 1
	  end
	  dp "Digg news saved to service"
	  return binder
		rescue
			ep "Trouble connecting to digg"
	end
end