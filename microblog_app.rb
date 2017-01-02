require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'

set :database, "sqlite3:test.sqlite3"
 enable :sessions

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get '/' do
	@users = User.all
	erb :home
end


get '/users' do
	@users = User.all
	erb :users
end

get '/users/new' do
	erb :newuser
end

post '/users/create' do
	@user = User.new(name: params['name'], password: params['password'])
	@user.save
	session[:user_id] = @user.id
	redirect "/users/#{@user.id}"
end

get '/users/:id' do
	@user = User.find(params['id'])
	@current_id = session[:user_id]
	@posts = @user.posts
if @user.id == @current_id
	erb :user
else
	erb :loginrequest
	end
end

get '/posts/new' do
	erb :newpost
end

post '/posts/create' do
	@post = Post.new(content: params['content'], post_id: params['post_id'], user_id: params['user_id'])
	@post.user_id = session[:user_id] 
	@post.save
	redirect "/users/#{session[:user_id]}/posts"
end

# get '/users/:id' do
# 	@user = User.find(params["id"])
# 	@posts = @user.posts
# 	erb :"user-posts"
	
# end

get '/users/:id/posts' do
	@user = User.find(params['id'])
	erb :posts
end

get '/browseposts' do
	@users = User.all
	@posts = Post.all.last(10)
	erb :browseposts
end

post '/login' do
	@user = User.where(name: params['name']).first
	if @user && @user.password == params['password'] 
		session[:user_id] = @user.id
		flash[:notice] = "You got it. You're in."
		redirect "/users/#{session[:user_id]}"
	else
		flash[:alert] = "Nope. Try again."
		redirect '/'
	end
end

post '/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/users/:id/edit' do
	@user = User.find(params['id'])
	erb :edituser
end

post'/users/:id/update' do
	@user = User.find(params['id'])
	@user.update(name: params['name'])
	redirect "/users/#{session[:user_id]}" 
end

post '/users/:id/delete' do
	@user = User.find(params['id'])
	@user.destroy
	redirect "/"

end