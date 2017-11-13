require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './models'
require 'pry'

enable :sessions

# Database configuration
set :database, "sqlite3:development.sqlite3"

# helper methods
# define current user
def current_user
  @user ||= User.find_by_id(session[:user_id])
end

# authenticate current user
def authenticate_user
  redirect '/login' if current_user.nil?
end

get '/login' do
  session[:login]=true
  erb :login
end

get '/logout' do
  session.clear
  redirect "/"
end

# Define routes below
get '/' do
  session[:login]=false
  current_user
  @messages = Message.all
  @users = User.all
  erb :index
end

# login
post '/login' do
  if User.find_by(username: params[:username].downcase) == nil
    user = User.create(username: params[:username], password: params[:password])
    session[:user_id]=user.id
    redirect "/"
  else
    user = User.find_by(username: params[:username].downcase)
    if user.password = params[:password]
        session[:user_id]=user.id
        redirect '/'
    else
      erb :login
    end
  end
end

post '/messages' do
  if !current_user
    redirect "/login"
  end
    message = Message.create(user_id:current_user.id, body:params[:body])
    redirect "/"
end

get '/messages/new' do
  erb :'messages/new'
end

get '/messages/:id' do
  @message = Message.find_by_id(params[:id])
  erb :'messages/show'
end

get '/profile/show/:id' do
  erb :'profile/show'
end

patch '/profile/edit/:id' do
    session[:edit_mode]=false
    current_user.update(fname: params[:first_name],lname: params[:last_name])
    redirect "/profile/show/#{params[:id]}"
end

post '/profile/edit/:id' do
    session[:edit_mode]=true
    redirect "/profile/show/#{params[:id]}"
end

delete '/profile/delete' do
  current_user
  @user.destroy
  session.clear
  redirect "/"
end

# Providing model information to the view
# requires an instance variable (prefixing with the '@' symbol)

# Example 'User' index route

# get '/users' do
#   @users = User.all
#   erb :users
# end
