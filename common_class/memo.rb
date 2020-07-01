class Memo
  attr_reader :title, :content
  def initialize(title:, content:)
    @title = title
    @content = content
  end

  class << self
    def read(connection)
      connection.exec("SELECT * FROM memos")
    end

    def select(connection, id)
      sql = "SELECT * FROM memos WHERE id = $1"
      connection.exec(sql, [id])
    end

    def throw_away(connection, id)
      sql = "DELETE FROM memos WHERE id = $1"
      connection.exec(sql, [id])
    end
  end

  def add(connection)
    sql = "INSERT INTO memos (title,content) VALUES ($1, $2)"
    connection.exec(sql, [title, content])
  end

  def edit(connection, id)
    sql = "UPDATE memos SET title=$1, content=$2 WHERE id = $3"
    connection.exec(sql, [title, content, id])
  end
end