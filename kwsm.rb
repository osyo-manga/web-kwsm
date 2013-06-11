# -*- encoding: UTF-8 -*-
require "bundler"
require "data_mapper"
require "mechanize"


DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_BLUE_URL'])


class ImageURLs
	include DataMapper::Resource

	property :id, Serial
	property :url, String, :length => 256, :unique => true
end
ImageURLs.auto_upgrade!


MATOME = [
	"http://yomigee.blog87.fc2.com/blog-entry-1615.html",
	"http://yomigee.blog87.fc2.com/blog-entry-1614.html"
]



class KWSM
	def initialize
		@image_urls = []

		agent = Mechanize.new
		@image_urls += MATOME.map {|url|
			agent.get(url).images_with(:src => /cg/)
		}.flatten

		@image_urls += ImageURLs.map(&:url)
	end
	attr_reader :image_urls

	def add url
		ImageURLs.first_or_create({:url => url})
		@image_urls << url unless @image_urls.include?(url)
	end

	def delete url
		item = ImageURLs.first({:url => url})
		item.destroy
		@image_urls.delete(url)
	end

	def get_image_url_random
		@image_urls[rand(@image_urls.length)]
	end
end


