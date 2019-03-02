

WANTED_KEYWORDS = %w[trad stock invest]
def keyword_in_line(line)
  line = line.downcase
  WANTED_KEYWORDS.each do |keyword|
    return keyword if line.index(keyword)
  end
  nil
end

def cashtag_in_line(line)
  match = /\$[A-Z]{3,5}/.match(line)
  return match.to_s if match
end

def relevent_tweet_from_handle(handle)
  page = Nokogiri::HTML(open("http://twitter.com/#{handle}")) 
  sleep(0.5)
  tweets = page.css('.tweet-text').map { |el| el.text }
  p tweets[0..4]
  tweet = tweets.find { |text| cashtag_in_line(text) }
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

  def self.analyze(csv_row, db)
    line = csv_row.join(',')
    hash = csv_row_to_hash(csv_row)
    handle = hash[:handle]

    if db.get_handle(handle)
      p "already in db: #{handle}"
      return
    end

    return if !valid_handle?(handle)
    
    reason = keyword_in_line(line) || cashtag_in_line(line) 

    if !reason
      tweet = relevent_tweet_from_handle(handle)
      if tweet
        hash[:relevant_tweet] = tweet
        reason = "tweet"
      end
    end

    if reason
      hash[:reason] = reason
      hash[:trader] = true
    end
    hash
  end
end