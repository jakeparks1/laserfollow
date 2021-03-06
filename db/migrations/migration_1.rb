require 'sequel'
require 'json'

secrets = JSON.parse( File.open("secrets.json").read )
connection_string = "postgres://#{secrets['psql_dbuser']}:#{secrets['psql_dbpassword']}@#{secrets['psql_dburl']}:#{secrets['psql_dbport']}/#{secrets['psql_dbname']}"

DB = Sequel.connect(connection_string)

DB.create_table :profiles do
  primary_key :id
  String :handle, null: false, unique: true, index: true
  String :name
  String :description, text: true 
  String :url
  String :location
  String :language
  Date :joined
  Bignum :twitter_user_id
  Bignum :tweets_count
  Fixnum :followers_count
  Fixnum :following_count
  DateTime :last_tweet_date
  String :last_tweet_text, size: 600
  String :referrer
  String :reason
  String :relevant_tweet, size: 600
  TrueClass :trader, default: false
  String :recent_tweets, text: true
   
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP, :index=>true
end