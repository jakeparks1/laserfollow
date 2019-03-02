require 'sequel'
require 'json'

secrets = JSON.parse( File.open("secrets.json").read )
connection_string = "postgres://#{secrets['psql_dbuser']}:#{secrets['psql_dbpassword']}@#{secrets['psql_dburl']}:#{secrets['psql_dbport']}/#{secrets['psql_dbname']}"

DB = Sequel.connect(connection_string)

DB.create_table :items do
  primary_key :id
  String :name
  Float :price
end

items = DB[:items] # Create a dataset

# Populate the table
items.insert(:name => 'abc', :price => rand * 100)
items.insert(:name => 'def', :price => rand * 100)
items.insert(:name => 'ghi', :price => rand * 100)

# Print out the number of records
puts "Item count: #{items.count}"

# Print out the average price
puts "The average price is: #{items.avg(:price)}"