
require 'sequel'

class PostgresDb
  attr_accessor :dataset
  def initialize
  end

  def load
    secrets = JSON.parse( File.open("secrets.json").read )
    connection_string = "postgres://#{secrets['psql_dbuser']}:#{secrets['psql_dbpassword']}@#{secrets['psql_dburl']}:#{secrets['psql_dbport']}/#{secrets['psql_dbname']}"
    @dataset = Sequel.connect(connection_string)[:profiles]
  end

  def append(data)
    allowed_keys = %i[handle name description url referrer location language 
      joined twitter_user_id tweets_count following_count followers_count last_tweet_date
      last_tweet_text reason relevant_tweet trader recent_tweets]
    new_data = data.reject { |key,value| !allowed_keys.include?(key) }
    new_data[:recent_tweets] = new_data[:recent_tweets] && new_data[:recent_tweets].any? ? new_data[:recent_tweets].to_s : nil
    p new_data
    begin
      @dataset.insert(new_data)
    rescue Sequel::UniqueConstraintViolation
      p "duplicate record for #{data[:handle]}"
    end
  end

  def get_handle(handle)
    @dataset.where(handle: handle).first
  end
end

