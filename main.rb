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
  attr_reader :contribution
  def initialize(id:, title:, content:)
    @contribution = {id: id, title: title, content:content}
  end
end

post "/new-memo" do
  @text = params[:text]
  text_lines = @text.split("\n",2)
  hash = {}
  File.open("./public/json/storehouse.json","r") do |file|
   hash =  JSON.load(file)
  end
  memo_id = hash["memos"].empty? ? 1 : (hash["memos"][-1]["id"] + 1)
  memo = Memo.new(id: memo_id, title:text_lines[0], content: text_lines[1])
  hash["memos"] ||= []
  hash["memos"].append(memo.contribution)
  File.open("./public/json/storehouse.json", "w") do |file|
    JSON.dump(hash, file)
  end
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
  text_lines = @text.split("\n",2)
  hash = {}
  File.open("./public/json/storehouse.json","r") do |file|
   hash =  JSON.load(file)
  end
  hash["memos"].delete_if {|memo| memo["id"] == @id.to_i}
  update_memo = Memo.new(id: @id.to_i, title:text_lines[0], content:text_lines[1])
  hash["memos"].append(update_memo.contribution)
  File.open("./public/json/storehouse.json", "w") do |file|
    JSON.dump(hash, file)
  end
  redirect to ("/#{@id}")
end

delete "/:id" do
  @id = params[:id]
  hash = {}
  File.open("./public/json/storehouse.json","r") do |file|
   hash =  JSON.load(file)
  end
  hash["memos"].delete_if {|memo| memo["id"] == @id.to_i}
  File.open("./public/json/storehouse.json", "w") do |file|
    JSON.dump(hash, file)
  end
  redirect to ("/")
end
