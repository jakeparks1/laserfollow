require 'csv'
require './db'
require 'pry'
require './mongodb'

filename = "files/twitonomy_investorslive_followers.csv"

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

db = MongoDb.new()
db.load

CSV.foreach(filename) do |row|
  line = row.join(",")
  reason = line_has_keyword?(line) || line_has_cashtag?(line)
  if reason
    handle = row[1]
    next if not handle

    p line
    p "\n"
    p "\n"
    db.append(handle, reason.to_s, row)
    break
  end
end





 