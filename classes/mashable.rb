require 'net/http'
require 'json'
require 'date'
require 'time'

class Mashable
	attr_reader :data
	def initialize
		@data = self.get
	end
	def get
    options = ["new","rising","hot"]
    #choice = options[rand(3)]
    mashableuri = URI("http://mashable.com/stories.json")
    mashable = JSON.parse(Net::HTTP.get(mashableuri))
    count = 0
	  art_num = 35
	  binder = []
	  mashable[options[0]].each do |stories|
	    binder[count] = {}
      binder[count][:title] = stories["title"]
      binder[count][:author] = stories["author"]
      binder[count][:datetime] = (Time.parse(stories["post_date_rfc"])).to_datetime
      binder[count][:url] = stories["link"]
      binder[count][:content] = stories["content"]["plain"]
      binder[count][:art_num] = art_num + 1
	    count += 1
	    art_num += 1
	  end
	  mashable[options[1]].each do |stories|
	    binder[count] = {}
      binder[count][:title] = stories["title"]
      binder[count][:author] = stories["author"]
      binder[count][:datetime] = (Time.parse(stories["post_date_rfc"])).to_datetime
      binder[count][:url] = stories["link"]
      binder[count][:content] = stories["content"]["plain"]
      binder[count][:art_num] = art_num + 1
	    count += 1
	    art_num += 1
	  end
	  mashable[options[2]].each do |stories|
	    binder[count] = {}
      binder[count][:title] = stories["title"]
      binder[count][:author] = stories["author"]
      binder[count][:datetime] = (Time.parse(stories["post_date_rfc"])).to_datetime
      binder[count][:url] = stories["link"]
      binder[count][:content] = stories["content"]["plain"]
      binder[count][:art_num] = art_num + 1
	    count += 1
	    art_num += 1
	  end
	  dp "Mashable news saved to service"
	  return binder

	end
end