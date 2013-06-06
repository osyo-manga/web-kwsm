# -*- encoding: UTF-8 -*-
# https://github.com/raa0121/raa0121-lingrbot/blob/master/dice.rb
require 'sinatra'
require 'json'
require "mechanize"


get '/' do
	"Hello, world"
end



# -------------------- kwsm --------------------

module KWSM
	urls = [
		"http://yomigee.blog87.fc2.com/blog-entry-1615.html",
		"http://yomigee.blog87.fc2.com/blog-entry-1614.html"
	]

	agent = Mechanize.new
	@@images = urls.map {|url|
		agent.get(url).images_with(:src => /cg/)
	}.flatten
	
	def image_rand
		@@images[rand(@@images.length)]
	end

	module_function:image_rand
end


get '/image' do
	"<img src=\"#{KWSM.image_rand.src}\">"
end


post '/lingr' do
	content_type :text
	json = JSON.parse(request.body.string)
	json["events"].select {|e| e['message'] }.map {|e|
		text = e["message"]["text"]
		if /^#kwsm/ =~ text || /わかるわ/u =~ text || /わからないわ/ =~ text
			return "わかるわ\n" + KWSM.image_rand.src
		end
	}
	return ""
end


