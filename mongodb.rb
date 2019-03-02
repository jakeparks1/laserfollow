
require "json"

require 'mongo'
require 'pry'

class MongoDb
  attr_accessor :client
  def load
    secrets = JSON.parse( File.open("secrets.json").read )
    dbuser = secrets["dbuser"]
    dbpassword = secrets["dbpassword"]
    dburl = secrets["dburl"]
    dbport = secrets["dbport"]
    dbname = secrets["dbname"]
    @client = Mongo::Client.new("mongodb://#{dbuser}:#{dbpassword}@#{dburl}:#{dbport}/#{dbname}")
    collection = @client[:profiles]
    collection.indexes.create_one({ handle: 1 }, unique: true)
  end

  def append(handle, reason)
    collection = @client[:profiles]
    doc = { 
      handle: handle,
      reason: reason
    }
    begin
      result = collection.insert_one(doc)
    rescue Mongo::Error::OperationFailure
      p "record already inserted"
    end
    #binding.pry
    #raise "This is wrong" unless result.n == 1 
  end

  def get_all
    collection.find.each do |document|
      #=> Yields a BSON::Document.
    end
  end
end