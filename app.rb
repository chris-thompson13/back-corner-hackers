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
# def current_user
#   @user ||= User.find_by_id(session[:user_id])
# end
#
# # authenticate current user
# def authenticate_user
#   redirect '/' if current_user.nil?
# end

# Define routes below
get '/' do
  @messages = Message.all
  @users = User.all
  erb :index
end

# login
post '/login' do
  username = params[:username].downcase
  user = User.find_or_create_by(username: username)
  session[:user_id] = user.id
  binding.pry
  redirect '/'
end

post '/messages' do
  message = Message.create(title:params[:title], body:params[:body])
  redirect "/"
end

get '/messages/new' do
  erb :'messages/new'
end

get '/messages/:id' do
  @message = Message.find_by_id(params[:id])
  erb :'messages/show'
end

# Providing model information to the view
# requires an instance variable (prefixing with the '@' symbol)

# Example 'User' index route

# get '/users' do
#   @users = User.all
#   erb :users
# end
