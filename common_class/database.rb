require "pg"

class DataBase
  attr_reader :config
  def initialize(host:, user:, dbname:)
    @config = { host: host, user: user, dbname: dbname }
  end

  def create_connection
    PG.connect(config)
  end
end
