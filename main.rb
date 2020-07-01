require "sinatra"
require "sinatra/reloader"
require "./common_class/memo"
require "pg"

config = {
  host: "localhost",
  user: "postgres",
  dbname: "memo_app"
}

connection = PG.connect(config)

get "/" do
  @title = "Memo App"
  @memos = Memo.read(connection)
  erb :top
end

get "/new-memo" do
  @title = "New memo"
  erb :newmemo
end

post "/new-memo" do
  @text = params[:text]
  text_lines = @text.split("\n", 2)
  memo = Memo.new(title: text_lines[0], content: text_lines[1])
  memo.add(connection)
  redirect to("/")
end

get "/:id" do
  @title = "show memo"
  @id = params[:id]
  @selected_memo = Memo.select(connection, @id.to_i)
  erb :show_memo
end

get "/:id/edit" do
  @title = "Edit memo"
  @id = params[:id]
  @selected_memo = Memo.select(connection, @id.to_i)
  erb :edit_memo
end

patch "/:id" do
  @text = params[:text]
  @id = params[:id]
  text_lines = @text.split("\n", 2)
  memo = Memo.new(title: text_lines[0], content: text_lines[1])
  memo.edit(connection, @id.to_i)
  redirect to ("/#{@id}")
end

delete "/:id" do
  @id = params[:id]
  Memo.throw_away(connection, @id.to_i)
  redirect to ("/")
end
