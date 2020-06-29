require "sinatra"
require "sinatra/reloader"
require "json"

get "/" do
  @title = "メモアプリ"
  erb :top
end

get "/new-memo" do
  @title = "New memo"
  erb :newmemo
end

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

post "/new-memo" do
  @text = params[:text]
  text_lines = @text.split("\n", 2)
  storage_location_path = "./public/json/storehouse.json"
  hash = Memo.read(storage_location_path)
  memo_id = hash["memos"].empty? ? 1 : (hash["memos"][-1]["id"] + 1)
  memo = Memo.new(id: memo_id, title: text_lines[0], content: text_lines[1])
  memo.add(hash, storage_location_path)
  redirect to("/")
end

get "/:id" do
  @title = "show memo"
  @id = params[:id]
  erb :show_memo
end

get "/:id/edit" do
  @title = "Edit memo"
  @id = params[:id]
  erb :edit_memo
end

patch "/:id" do
  @text = params[:text]
  @id = params[:id]
  text_lines = @text.split("\n", 2)
  storage_location_path = "./public/json/storehouse.json"
  hash = Memo.read(storage_location_path)
  Memo.throw_away(hash, @id.to_i)
  memo = Memo.new(id: @id.to_i, title: text_lines[0], content: text_lines[1])
  memo.add(hash, storage_location_path)
  redirect to ("/#{@id}")
end

delete "/:id" do
  @id = params[:id]
  hash = Memo.read("./public/json/storehouse.json")
  Memo.throw_away(hash, @id.to_i)
  File.open("./public/json/storehouse.json", "w") do |file|
    JSON.dump(hash, file)
  end
  redirect to ("/")
end
