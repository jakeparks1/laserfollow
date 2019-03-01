require 'csv'
require './db'
require 'pry'
filename = "files/twitonomy_investorslive_followers.csv"

db = Db.new()
db.load

CSV.foreach(filename) do |row|
  line = row.join(",")
  lowercase_line = line.downcase
  if lowercase_line.index("trad") || lowercase_line.index("stock") || /\$[A-Z]{3,5}/.match(line)
    handle = row[1]
    next if not handle
    db.append(handle)
  end

end

 