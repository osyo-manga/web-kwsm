# -*- encoding: UTF-8 -*-
require "bundler"
require 'sinatra'
require 'json'
require "mechanize"
load "kwsm.rb"

kwsm = KWSM.new


get '/' do
	"わかるわ"
end


get '/image_random' do
	"<img src=\"#{kwsm.get_image_url_random}\">"
end

get '/image_all' do
	kwsm.image_urls.map {|url| "<a href=\"#{url}\"><img src=\"#{url}\" width=\"20%\"></a>" }.join
end


get '/image_list' do
	kwsm.image_urls.join("<br>")
end


post '/lingr' do
	content_type :text
	json = JSON.parse(request.body.string)
	json["events"].select {|e| e['message'] }.map {|e|
		text = e["message"]["text"]
		if /^#kwsm$/ =~ text || /わかるわ$/u =~ text || /わからないわ$/ =~ text
			return "わかるわ\n" + kwsm.get_image_url_random
		end
		case text
		when /^#kwsm[\s　]+add[\s　]+(.+)/
			kwsm.add(text[/^#kwsm[\s　]+add[\s　]+(.+)/, 1])
			return "追加されたのね、わかるわ"
		when /^#kwsm[\s　]+delete[\s　]+(.+)/
			kwsm.delete(text[/^#kwsm[\s　]+delete[\s　]+(.+)/, 1])
			return "削除されたのね、わからないわ"
		end
	}
	return ""
end


