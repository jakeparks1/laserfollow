require 'set'
class Db
  attr_accessor :handles
  DB_FILE_NAME = 'db/db.txt'

  def initialize() 
    @handles = Set.new
  end

  def load()
    return unless File.file?(DB_FILE_NAME)
    File.open(DB_FILE_NAME, 'r') do |file|
      data = file.read
      data = data.split("\n")
      @handles = Set.new(data)
    end
  end

  def append(handle)
    @handles.add(handle)
    File.open(DB_FILE_NAME, "a") {|f| f.write(handle + "\n") }
  end
end