



WANTED_KEYWORDS = %w[trad stock invest]
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

def valid_handle?(handle)
  return if !handle
  !!(/^\@/.match(handle))
end

def csv_row_to_hash(csv_row)
  return if !csv_row.count == 18
  h = {}
  h[:handle], h[:name], h[:description], h[:url], h[:location], h[:language],
  h[:joined], h[:twitter_user_id], h[:tweets_count], h[:followers_count],
  h[:following_count], h[:listed_count], h[:favourite_count],
  h[:last_tweet_date], h[:last_tweet_text] = csv_row[1..15]
  h
end

class TraderInterest

  def self.analyze(csv_row)
    line = csv_row.join(',')
    hash = csv_row_to_hash(csv_row)
    return if !valid_handle?(hash[:handle])
    reason = line_has_keyword?(line) || line_has_cashtag?(line)
    return hash if reason
  end
end