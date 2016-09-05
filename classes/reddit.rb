require 'net/http'
require 'json'
require 'date'
require 'time'

class Reddit
	attr_reader :data
	def initialize
		@data = self.get
	end
	def get
    endpoint = 'www.reddit.com'
    resource = "/.json"
    uri = URI("https://#{endpoint}#{resource}")
    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = "vand\'s NBC news service"
    response =  Net::HTTP.start(uri.hostname){|http| http.request(request)}
    reddit = JSON.parse(response.body)
	  count = 0
	  art_num = 10
	  binder = []
	  reddit["data"]["children"].each do |children|
	    binder[count] = {}
      binder[count][:title] = children["data"]["title"]
      binder[count][:author] = children["data"]["author"]
      binder[count][:datetime] = (Time.at(children["data"]["created"])).to_datetime
      binder[count][:url] = children["data"]["url"]
      binder[count][:content] = "subreddit - /#{children["data"]["subreddit"]}"
      binder[count][:art_num] = art_num + 1
	    count += 1
	    art_num += 1
	  end
	  dp "Reddit news saved to service"
	  return binder
		rescue
			ep "Trouble connecting to reddit"
	end
end