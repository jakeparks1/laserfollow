
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

  def append(handle, reason, row_raw)
    collection = @client[:profiles]
    doc = { 
      handle: handle,
      reason: reason,
      row_raw: row_raw
    }
    result = collection.insert_one(doc)
    #binding.pry
    raise "This is wrong" unless result.n == 1 
  end
end