require 'csv'
require './db/drivers/postgres_db'
require 'pry'
require './twitter_browser'
require './trader_interest'

referrer = "occupywisdom"
filename = "files/twitonomy_#{referrer}_followers.csv"

SKIP_TWEET_ANALYSIS=true
db = PostgresDb.new()
db.load

CSV.foreach(filename) do |row|
  results = TraderInterest.analyze(row, db, skip_tweet_analysis=SKIP_TWEET_ANALYSIS)
  if results 
    results[:referrer] = referrer
    results[:blah] = "blah"
    db.append(results)
  end

end





 