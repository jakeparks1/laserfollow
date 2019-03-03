require 'csv'
require './db/drivers/postgres_db'
require 'pry'
require './twitter_browser'
require './trader_interest'


SKIP_TWEET_ANALYSIS=false
db = PostgresDb.new()
db.load

files = Dir["files/*"]

def determine_trader_interest_for_file(filename, db)
  p "determine_trader_interest_for_file #{filename}"

  referrer = /twitonomy_(\w+)_followers.csv/.match(filename)[1]

  CSV.foreach(filename) do |row|
    results = TraderInterest.analyze(row, db, skip_tweet_analysis=SKIP_TWEET_ANALYSIS)
    if results 
      results[:referrer] = referrer
      results[:blah] = "blah"
      db.append(results)
    end
  end
end


files.each do |file|
  determine_trader_interest_for_file(file, db)
end



 