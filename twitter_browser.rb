require 'nokogiri'
require 'open-uri'
require 'pry'
class TwitterBrowser

  def get_recent_tweets(handle)
    page = Nokogiri::HTML(open("http://twitter.com/#{handle}")) 
    # the first 5 tweets
    (0..5).map { |n| page.css("li.js-stream-item")[n].text }
  end
end

