class Memo
  attr_reader :page
  def initialize(id:, title:, content:)
    @page = { id: id, title: title, content: content }
  end

  class << self
    def read(path)
      file = File.read(path)
      JSON.load("#{file}")
    end

    def select(hash, id)
      hash["memos"].find { |memo| memo["id"] == id }
    end

    def throw_away(hash, id)
      hash["memos"].delete_if { |memo| memo["id"] == id }
    end
  end

  def add(hash, path)
    hash["memos"] ||= []
    hash["memos"].push(page)
    File.open("#{path}", "w") do |file|
      JSON.dump(hash, file)
    end
  end
end
