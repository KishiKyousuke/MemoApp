class Memo
  attr_reader :title, :content, :connection
  def initialize(title:, content:)
    @title = title
    @content = content
  end

  class << self
    def read(connection)
      connection.exec("SELECT * FROM memos")
    end

    def select(connection,id)
      connection.exec("SELECT * FROM memos WHERE id = #{id}")
    end

    def throw_away(connection,id)
      connection.exec("DELETE FROM memos WHERE id = #{id}")
    end
  end

  def add(connection)
    connection.exec("INSERT INTO memos (title,content) VALUES ('#{title}', '#{content}')")
  end

  def edit(connection,id)
    connection.exec("UPDATE memos SET title='#{title}', content='#{content}' WHERE id = #{id}")
  end
end

