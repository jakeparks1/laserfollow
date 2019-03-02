

class PostgresDb
  attr_accessor :client
  def initialize
  end


  def load
    secrets = JSON.parse( File.open("secrets.json").read )
    connection_string = "postgres://#{secrets['psql_dbuser']}:#{secrets['psql_dbpassword']}@#{secrets['psql_dburl']}:#{secrets['psql_dbport']}/#{secrets['psql_dbname']}"
    @client = Sequel.connect(connection_string)
  end

  def append
  end
end