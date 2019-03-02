require 'csv'
require './db'
require 'pry'
require './mongodb'
require './twitter_browser'
filename = "files/twitonomy_investorslive_followers.csv"

WANTED_KEYWORDS = %w[trad stock invest]
db = Db.new()
db.load



def line_has_keyword?(line)
  line = line.downcase
  WANTED_KEYWORDS.each do |keyword|
    return keyword if line.index(keyword)
  end
  false
end

def line_has_cashtag?(line)
  return /\$[A-Z]{3,5}/.match(line)
end

def handle_has_relevant_tweets?(handle)
  browser = TwitterBrowser.new()
  tweets = browser.get_recent_tweets(handle)
  tweet_data = tweets.join("\n")
  line_has_keyword?(tweet_data) || line_has_cashtag?(tweet_data)
end

CSV.foreach(filename) do |row|
  line = row.join(",")
  handle = row[1]
  next if (not handle) or /^\@/.match(handle).nil?
  reason = line_has_keyword?(line) || line_has_cashtag?(line)
  if not reason
    success = handle_has_relevant_tweets?(handle)
    binding.pry
  end
  if reason
    handle = row[1]
    next if not handle

    p line
    p "\n"
    p "\n"
    db.append(handle)
    break
  end
end





 